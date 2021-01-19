defmodule Freegiving.Services.GiftCardService do
  @moduledoc """
  The gift card service handles event re. gift cards
  """

  alias Freegiving.{Repo, Mailer, Mishap}
  alias Freegiving.Fundraisers.Fundraiser
  alias Swoosh.Email
  alias Freegiving.Services.MishapService

  import Freegiving.Services.Utils,
    only: [acting_primary_admin_and_others: 1, fundraiser_with_store_contact: 1]

  require Logger

  def gift_card_assigned(gift_card) do
    Logger.info(
      "Gift card no. #{gift_card.card_number} was assigned to participant #{
        gift_card.participant_id
      }. Checking if re-supply required."
    )

    fundraiser = Repo.get_by!(Fundraiser, id: gift_card.fundraiser_id)

    reserve_count =
      fundraiser
      |> Repo.preload(:gift_cards)
      |> Map.get(:gift_cards)
      |> Enum.filter(&(&1.participant_id == nil))
      |> Enum.count()

    # Only when we reach the threshold, or empty, else resupply requested continually
    if reserve_count == 0 or reserve_count == fundraiser.card_reserve_low_mark do
      Logger.info(
        "Fundraiser #{fundraiser.id} has #{fundraiser.card_reserve_low_mark} unassigned cards. Ordering re-supply."
      )

      order_gift_card_resupply(fundraiser.id, fundraiser.card_reserve_max - reserve_count)
    else
      Logger.info("Fundraiser #{fundraiser.id} has #{reserve_count} unassigned cards.")
      :ok
    end
  end

  defp order_gift_card_resupply(fundraiser_id, count) do
    Logger.info("Ordering #{count} gift cards for fundraiser #{fundraiser_id}")

    with {:ok, fundraiser, store_contact} <- fundraiser_with_store_contact(fundraiser_id),
         {:ok, primary_admin, other_admins} <-
           acting_primary_admin_and_others(fundraiser) do
      data = %{
        fundraiser: fundraiser,
        store_contact: store_contact,
        primary_admin: primary_admin,
        other_admins: other_admins,
        number_of_cards: count
      }

      email_card_resupply(data)
    else
      other ->
        Logger.warn("OTHER = #{inspect(other)}")

        MishapService.report_mishap(%Mishap{
          doing: "#{__MODULE__}:order_gift_card_resupply",
          with: [fundraiser_id, count],
          causing: other
        })
    end
  end

  defp email_card_resupply(data) do

    body = """
    Please send #{data.number_of_cards} inactive gift cards at your earliest convenience to

    #{data.primary_admin.contact.name}
    #{data.primary_admin.contact.address}

    Thank you,

    #{data.primary_admin.contact.name}
    #{data.fundraiser.name}
    """

    cc = Enum.map(data.other_admins, &{&1.contact.name, &1.contact.email})

    email =
      Email.new()
      |> Email.to({data.store_contact.name, data.store_contact.email})
      |> Email.cc(cc)
      |> Email.from({data.primary_admin.contact.name, data.primary_admin.contact.email})
      |> Email.subject("Request for inactive gift cards")
      |> Email.text_body(body)

    Logger.info("Sending email #{inspect(email)}")
    Mailer.deliver!(email)
  end
end
