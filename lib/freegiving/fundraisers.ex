defmodule Freegiving.Fundraisers do
  @moduledoc "The Fundraisers context"

  import Ecto.Query, warn: false
  alias Freegiving.Repo

  alias Freegiving.Fundraisers.{
    School,
    Store,
    PaymentService,
    PaymentMethod,
    Contact,
    Fundraiser,
    Participant,
    GiftCard,
    RefillRound,
    CardRefill
  }

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

  def register_payment_service(attrs) do
    %PaymentService{}
    |> PaymentService.changeset(attrs)
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
      Repo.transaction(fn ->
        fundraiser =
          %Fundraiser{school_id: school.id, store_id: store.id, store_contact_id: contact.id}
          |> Fundraiser.changeset(attrs)
          |> Repo.insert!()

        insert_refill_round!(fundraiser)

        fundraiser
      end)
    else
      {:error, :failed}
    end
  end

  def register_payment_method(attrs,
        fundraiser_id: fundraiser_id,
        payment_service_name: payment_service_name
      ) do
    payment_service = Repo.one(PaymentService, name: payment_service_name)

    %PaymentMethod{fundraiser_id: fundraiser_id, payment_service_id: payment_service.id}
    |> PaymentMethod.changeset(attrs)
    |> Repo.insert()
  end

  def register_participant(attrs,
        contact: contact_attrs,
        fundraiser_name: fundraiser_name,
        user_email: user_email
      ) do
    user = Repo.get_by(User, email: user_email)
    fundraiser = Repo.get_by(Fundraiser, name: fundraiser_name)

    if user != nil and fundraiser != nil and fundraiser.active do
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
    if participant.active do
      Ecto.build_assoc(participant, :gift_cards)
      |> GiftCard.changeset(attrs)
      |> Repo.insert()
    else
      {:error, :failed}
    end
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

  def close_current_refill_round(%Fundraiser{} = fundraiser) do
    Repo.transaction(fn ->
      current_refill_round(fundraiser)
      |> Repo.preload(:fundraiser)
      |> Repo.preload(:card_refills)
      |> RefillRound.changeset(%{closed_on: DateTime.utc_now() |> DateTime.to_string()})
      |> Repo.update!()

      insert_refill_round!(fundraiser)
    end)
  end

  def request_card_refill(attrs,
        card_number: card_number,
        payment_service_name: payment_service_name
      ) do
    Repo.transaction(fn ->
      gift_card = Repo.one(GiftCard, card_number: card_number)
      card_refill_with_fundraiser = Repo.preload(gift_card, :fundraiser)
      fundraiser_id = card_refill_with_fundraiser.fundraiser.id
      fundraiser_active!(fundraiser_id)
      payment_method = payment_method(fundraiser_id, payment_service_name)
      current_refill_round = current_refill_round(fundraiser_id)

      %CardRefill{
        gift_card_id: gift_card.id,
        refill_round_id: current_refill_round.id,
        payment_method_id: payment_method.id
      }
      |> CardRefill.changeset(attrs)
      |> Repo.insert()
    end)
  end

  defp fundraiser_active!(fundraiser_id) do
    fundraiser = Repo.one(Fundraiser, id: fundraiser_id)

    if fundraiser == nil or not fundraiser.active do
      raise("Not an active fundraiser")
    else
      :ok
    end
  end

  defp current_refill_round(fundraiser_id) do
    loaded_fundraiser =
      Repo.one(Fundraiser, id: fundraiser_id)
      |> Repo.preload(:refill_rounds)

    Enum.find(loaded_fundraiser.refill_rounds, &(&1.closed_on == nil))
  end

  defp insert_refill_round!(fundraiser) do
    Ecto.build_assoc(fundraiser, :refill_rounds)
    |> RefillRound.changeset(%{})
    |> Repo.insert!()
  end

  defp payment_method(fundraiser_id, payment_service_name) do
    payment_service = Repo.one(PaymentService, name: payment_service_name)
    Repo.one(PaymentMethod, payment_service_id: payment_service.id, fundraiser_id: fundraiser_id)
  end
end
