defmodule Freegiving.Fundraisers do
  @moduledoc "The Fundraisers context"

  import Ecto.Query, warn: false
  alias Freegiving.Repo
  alias Freegiving.Fundraisers.{School, Store, Contact, Fundraiser, Participant, GiftCard}
  alias Freegiving.Accounts.User

  def register_school(attrs) do
    %School{}
    |> School.changeset(attrs)
    |> Repo.insert()
  end

  def register_store(attrs) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  def register_contact(attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  def register_contact_if_new(%{email: email} = attrs) do
    case Repo.get_by(Contact, email: email) do
      nil ->
        register_contact(attrs)

      contact ->
        {:ok, contact}
    end
  end

  def register_fundraiser(attrs,
        school_name: school_name,
        store_name: store_name,
        store_contact_email: store_contact_email
      ) do
    store = Repo.get_by(Store, name: store_name)
    school = Repo.get_by(School, name: school_name)
    contact = Repo.get_by(Contact, email: store_contact_email)

    if store != nil and school != nil and contact != nil do
      %Fundraiser{school_id: school.id, store_id: store.id, store_contact_id: contact.id}
      |> Fundraiser.changeset(attrs)
      |> Repo.insert()
    else
      {:error, :failed}
    end
  end

  def register_participant(attrs,
        contact: contact_attrs,
        fundraiser_name: fundraiser_name,
        user_email: user_email
      ) do
    user = Repo.get_by(User, email: user_email)
    fundraiser = Repo.get_by(Fundraiser, name: fundraiser_name)

    if user != nil and fundraiser != nil do
      case register_contact_if_new(contact_attrs) do
        {:ok, contact} ->
          %Participant{fundraiser_id: fundraiser.id, user_id: user.id, contact_id: contact.id}
          |> Participant.changeset(attrs)
          |> Repo.insert()
      end
    else
      {:error, :failed}
    end
  end

  def add_gift_card(%Participant{} = participant, attrs) do
    Ecto.build_assoc(participant, :gift_cards)
    |> GiftCard.changeset(attrs)
    |> Repo.insert()
  end

  def get_participant(fundraiser_name: fundraiser_name, user_email: user_email) do
    query =
      from p in Participant,
        join: f in Fundraiser,
        on: p.fundraiser_id == f.id,
        join: u in User,
        on: p.user_id == u.id,
        where: f.name == ^fundraiser_name,
        where: u.email == ^user_email,
        select: p.id

    case Repo.one(query) do
      nil ->
        nil

      participant_id ->
        Repo.one(Participant, id: participant_id)
        |> Repo.preload(:gift_cards)
        |> Repo.preload(:contact)
    end
  end
end
