defmodule Freegiving.Services.RefillRoundService do
  @moduledoc """
  Refill round activities.
  """

  use Freegiving.Eventing
  alias Freegiving.Error
  alias Freegiving.Fundraisers.{RefillRound, Fundraiser}
  alias Freegiving.Repo
  require Logger

  def refill_round_closed(%RefillRound{fundraiser_id: fundraiser_id} = refill_round) do
    # make a CSV from the refill requests
    # send an email to the store contact, cc to fundraiser admins
    with {:ok, csv_file} <- csv_file(refill_round) do
      fundraiser =
        Repo.get_by(Fundraiser, id: fundraiser_id)
        |> Repo.preload(:fundraiser_admins)
        |> Repo.preload(:store_contacts)

      store_contact = fundraiser.store_contact

      fundraiser_admin_contacts =
        for fundraiser_admin <- fundraiser.fundraiser_admins do
          Repo.preload(fundraiser_admin, :contact).contact
        end

      email_csv_file(store_contact, fundraiser_admin_contacts, csv_file)
    else
      {:error, reason} ->
        publish(:error, %Error{
          doing: "Processing closed refill round",
          with: [refill_round],
          causing: reason
        })
    end
  end

  defp csv_file(refill_round) do
    card_refills = Repo.preload(refill_round, :card_refills).card_refills |> Enum.map(&(Repo.preload(&1, :gift_card)))
    # TODO
    {:error, :failed}
  end

  defp email_csv_file(_store_contact, _fundraiser_admin_contacts, _csv_file) do
    # TODO
    Logger.info("Closed refill round CSV emailed")
    {:error, :failed}
  end
end
