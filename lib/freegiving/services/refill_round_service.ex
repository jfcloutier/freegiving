defmodule Freegiving.Services.RefillRoundService do
  @moduledoc """
  Refill round activities.
  """

  use Freegiving.Eventing
  alias Freegiving.{Mishap, Repo, Mailer, Fundraisers}
  alias Freegiving.Fundraisers.RefillRound
  alias Swoosh.{Email, Attachment}

  import Freegiving.Services.Utils,
    only: [acting_primary_admin_and_others: 1, month_name: 1, fundraiser_with_store_contact: 1]

  require Logger

  def close_current_refill_round(fundraiser_id) do
    pub(:refill_round_closed) do
      Repo.transaction(fn ->
        fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

        closed_refill_round =
          Fundraisers.current_refill_round(fundraiser)
          |> Repo.preload(:fundraiser)
          |> Repo.preload(:card_refills)
          |> RefillRound.changeset(%{closed_on: DateTime.utc_now() |> DateTime.to_string()})
          |> Repo.update!()

        Fundraisers.start_new_refill_round!(fundraiser)
        closed_refill_round
      end)
    end
  end

  def refill_round_closed(%RefillRound{fundraiser_id: fundraiser_id} = refill_round) do
    Logger.info("Refill round closed. Sending refill request.")
    # make a CSV from the refill requests
    # send an email to the store contact, cc to fundraiser admins
    card_refills =
      Repo.preload(refill_round, :card_refills).card_refills
      |> Enum.reject(&(&1.amount == 0))
      |> Enum.map(&Repo.preload(&1, :gift_card))

    number_of_cards = Enum.count(card_refills)
    number_of_new_cards = Enum.filter(card_refills, &(not &1.gift_card.active)) |> Enum.count()
    total_amount = card_refills |> Enum.map(& &1.amount) |> Enum.sum()

    if number_of_cards > 0 do
      with {:ok, csv} <- make_csv(card_refills),
           {:ok, fundraiser, store_contact} <- fundraiser_with_store_contact(fundraiser_id),
           {:ok, primary_admin, other_admins} <-
             acting_primary_admin_and_others(fundraiser) do
        data = %{
          fundraiser: fundraiser,
          store_contact: store_contact,
          primary_admin: primary_admin,
          other_admins: other_admins,
          number_of_cards: number_of_cards,
          number_of_new_cards: number_of_new_cards,
          total_amount: total_amount
        }

        email_csv(data, csv)
      else
        {:error, reason} ->
          publish(:mishap, %Mishap{
            doing: "Processing closed refill round",
            with: [refill_round],
            causing: reason
          })
      end
    else
      publish(:mishap, %Mishap{
        doing: "No card refill in refill round",
        with: [refill_round],
        causing: "No card refill with a non-zero amount"
      })
    end
  end

  # gift_card_number, refill_amount, participant_name
  defp make_csv(card_refills) do
    csv_records =
      card_refills
      |> Enum.reduce(
        [],
        fn card_refill, acc ->
          card_number = card_refill.gift_card.number

          maybe_new_card_issued =
            if not card_refill.gift_card.active, do: "\t\tNew card issued", else: ""

          ["#{card_number},#{card_refill.amount},#{maybe_new_card_issued}" | acc]
        end
      )

    if Enum.empty?(csv_records) do
      {:error, "Card refills CSV is empty"}
    else
      csv = "card number,refill amount,card holder\n" <> Enum.join(csv_records, "\n")
      {:ok, csv}
    end
  end

  defp email_csv(data, csv) do
    body = """
    Please process the attached bulk reload file.  There should be #{data.number_of_cards} cards for a total of $#{
      data.total_amount
    }.00 (prior to discount).

    Please note there are #{data.number_of_new_cards} cards that are new and will need to be activated as well.

    I can be reached at #{data.primary_admin.contact.phone} for payment.

    Also, please advise when the online reload process will be available.

    Thank you,

    #{data.primary_admin.contact.name}
    #{data.fundraiser.name}
    """

    cc = Enum.map(data.other_admins, &{&1.contact.name, &1.contact.email})
    filename = filename()
    attachment = Attachment.new({:data, csv}, filename: filename, content_type: "text/csv")

    email =
      Email.new()
      |> Email.to({data.store_contact.name, data.store_contact.email})
      |> Email.cc(cc)
      |> Email.from({data.primary_admin.contact.name, data.primary_admin.contact.email})
      |> Email.subject("Bulk Reload File")
      |> Email.text_body(body)
      |> Email.attachment(attachment)

    Logger.info("Sending email #{inspect(email)}")
    Mailer.deliver!(email)
  end

  defp filename() do
    date = DateTime.utc_now() |> DateTime.to_date()
    "#{month_name(date.month)} #{date.day} #{date.year}.csv"
  end
end
