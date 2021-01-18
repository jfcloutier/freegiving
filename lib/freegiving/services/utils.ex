defmodule Freegiving.Services.Utils do
  @moduledoc """
  Service utilities
  """

  alias Freegiving.Repo
  alias Freegiving.Fundraisers.Fundraiser
  require Logger

  def fundraiser_with_store_contact(fundraiser_id) do
    fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

    if fundraiser.store_contact_id != nil do
      store_contact = Repo.preload(fundraiser, :store_contact).store_contact
      {:ok, fundraiser, store_contact}
    else
      {:error, "No store contact for fundraiser #{fundraiser_id}"}
    end
  end

  # Find a fundraiser's admin that's a primary, or else any admin for the fundraiser,
  # and the other admins.
  # Fail if no one
  def acting_primary_admin_and_others(not_preloaded_fundraiser) do
    fundraiser = Repo.preload(not_preloaded_fundraiser, [:store_contact, :fundraiser_admins])

    case fundraiser.fundraiser_admins do
      [] ->
        {:error, "No fundraiser admins to send CSV from in fundraiser #{fundraiser.id}"}

      fundraiser_admins ->
        acting_primary =
          case Enum.filter(fundraiser_admins, & &1.primary) do
            [] -> Enum.random(fundraiser_admins)
            primaries -> Enum.random(primaries)
          end
          |> Repo.preload(:contact)

        other_admins =
          for fundraiser_admin <- fundraiser.fundraiser_admins,
              fundraiser_admin.id != acting_primary.id do
            Repo.preload(fundraiser_admin, :contact)
          end

        {:ok, acting_primary, other_admins}
    end
  end

  def month_name(1), do: "January"
  def month_name(2), do: "February"
  def month_name(3), do: "March"
  def month_name(4), do: "April"
  def month_name(5), do: "May"
  def month_name(6), do: "June"
  def month_name(7), do: "July"
  def month_name(8), do: "August"
  def month_name(9), do: "September"
  def month_name(10), do: "October"
  def month_name(11), do: "November"
  def month_name(12), do: "December"
end
