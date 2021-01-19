defmodule Freegiving.Fundraisers do
  @moduledoc "The Fundraisers context - CRUD"

  import Ecto.Query, warn: false
  alias Freegiving.Repo
  require Logger

  use Freegiving.Eventing

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
    CardRefill,
    FundraiserAdmin
  }

  alias Freegiving.Accounts.User

  def register_school(attrs) do
    pub(:added) do
      %School{}
      |> School.changeset(attrs)
      |> Repo.insert()
    end
  end

  def register_store(attrs) do
    pub(:added) do
      %Store{}
      |> Store.changeset(attrs)
      |> Repo.insert()
    end
  end

  def register_payment_service(attrs) do
    pub(:added) do
      %PaymentService{}
      |> PaymentService.changeset(attrs)
      |> Repo.insert()
    end
  end

  def register_contact(attrs) do
    pub(:added) do
      %Contact{}
      |> Contact.changeset(attrs)
      |> Repo.insert()
    end
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
    pub(:added) do
      store = Repo.get_by(Store, name: store_name)
      school = Repo.get_by(School, name: school_name)
      contact = Repo.get_by(Contact, email: store_contact_email)

      if store != nil and school != nil and contact != nil do
        Repo.transaction(fn ->
          fundraiser =
            %Fundraiser{school_id: school.id, store_id: store.id, store_contact_id: contact.id}
            |> Fundraiser.changeset(attrs)
            |> Repo.insert!()

          start_new_refill_round!(fundraiser)

          fundraiser
        end)
      else
        {:error, :failed}
      end
    end
  end

  def register_gift_card(attrs, fundraiser_id: fundraiser_id) do
    pub(:added) do
      fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

      Ecto.build_assoc(fundraiser, :gift_cards)
      |> GiftCard.changeset(attrs)
      |> Repo.insert()
    end
  end

  def register_payment_method(attrs,
        fundraiser_id: fundraiser_id,
        payment_service_name: payment_service_name
      ) do
    pub(:added) do
      payment_service = Repo.get_by(PaymentService, name: payment_service_name)

      %PaymentMethod{fundraiser_id: fundraiser_id, payment_service_id: payment_service.id}
      |> PaymentMethod.changeset(attrs)
      |> Repo.insert()
    end
  end

  def register_participant(attrs,
        contact: contact_attrs,
        fundraiser_id: fundraiser_id,
        user_email: user_email
      ) do
    pub(:added) do
      user = Repo.get_by(User, email: user_email)
      fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

      if user != nil and fundraiser != nil and fundraiser.active do
        Repo.transaction(fn ->
          case register_contact_if_new(contact_attrs) do
            {:ok, contact} ->
              %Participant{fundraiser_id: fundraiser.id, user_id: user.id, contact_id: contact.id}
              |> Participant.changeset(attrs)
              |> Repo.insert!()

            {:error, changeset} ->
              Repo.rollback(changeset)
          end
        end)
      else
        {:error, :failed}
      end
    end
  end

  def register_fundraiser_admin(
        %{
          user_email: user_email,
          contact: contact_attrs,
          primary: primary?
        },
        fundraiser_id: fundraiser_id
      ) do
    pub(:added) do
      Repo.transaction(fn ->
        user = Repo.get_by!(User, email: user_email)
        fundraiser = Repo.get_by!(Fundraiser, id: fundraiser_id)
        {:ok, contact} = register_contact_if_new(contact_attrs)

        %FundraiserAdmin{fundraiser_id: fundraiser.id, user_id: user.id, contact_id: contact.id}
        |> FundraiserAdmin.changeset(%{primary: primary?})
        |> Repo.insert!()
      end)
    end
  end

  def assign_gift_card(attrs, participant_id: participant_id) do
    pub(:gift_card_assigned) do
      Repo.transaction(fn ->
        participant = Repo.get_by(Participant, id: participant_id)

        case Repo.all(
               from gc in "gift_cards",
                 where: gc.fundraiser_id == ^participant.fundraiser_id,
                 where: is_nil(gc.participant_id),
                 select: [:card_number]
             ) do
          [] ->
            reason = "All gift cards for fundraiser #{participant.fundraiser_id} have been assigned"
            Repo.rollback(reason)
            {:error, reason}

          [answer | _] ->
            if participant.active do
              Repo.get_by(GiftCard, card_number: answer.card_number)
              |> Repo.preload(:participant)
              |> GiftCard.changeset(attrs)
              |> Ecto.Changeset.put_assoc(:participant, participant)
              |> Repo.update!()
            else
              reason = "Failed to assign gift card to inactive participant #{participant_id}"
              Logger.warn(reason)
              Repo.rollback(reason)
              {:error, reason}
            end
        end
      end)
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
        Repo.get_by(Participant, id: participant_id)
        |> Repo.preload(:gift_cards)
        |> Repo.preload(:contact)
    end
  end

  def close_current_refill_round(fundraiser_id) do
    pub(:refill_round_closed) do
      Repo.transaction(fn ->
        fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

        closed_refill_round =
          current_refill_round(fundraiser)
          |> Repo.preload(:fundraiser)
          |> Repo.preload(:card_refills)
          |> RefillRound.changeset(%{closed_on: DateTime.utc_now() |> DateTime.to_string()})
          |> Repo.update!()

        start_new_refill_round!(fundraiser)
        closed_refill_round
      end)
    end
  end

  def request_card_refill(attrs,
        card_number: card_number,
        payment_service_name: payment_service_name
      ) do
    pub(:added) do
      Repo.transaction(fn ->
        gift_card = Repo.get_by(GiftCard, card_number: card_number)
        gift_card_participant_active!(gift_card)
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
  end

  def make_fundraiser_active(fundraiser_id, active?) do
    Repo.get_by(Fundraiser, id: fundraiser_id)
    |> Fundraiser.changeset(%{active: active?})
    |> Repo.update()
  end

  def fundraiser_active?(fundraiser_id) do
    case Repo.get_by(Fundraiser, id: fundraiser_id) do
      nil -> false
      fundraiser -> fundraiser.active
    end
  end

  def make_participant_active(participant_id, active?) do
    Repo.get_by(Participant, id: participant_id)
    |> Participant.changeset(%{active: active?})
    |> Repo.update()
  end

  def participant_active?(participant_id) do
    case Repo.get_by(Participant, id: participant_id) do
      nil -> false
      participant -> participant.active
    end
  end

  defp fundraiser_active!(fundraiser_id) do
    fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

    if fundraiser == nil or not fundraiser.active do
      raise("Not an active fundraiser")
    else
      :ok
    end
  end

  defp gift_card_participant_active!(gift_card) do
    if gift_card.participant_id == nil do
      raise("Gift card not assigned to a participant")
    else
      participant = Repo.get_by(Participant, id: gift_card.participant_id)

      if participant == nil or not participant.active do
        raise("Not an active participant")
      else
        :ok
      end
    end
  end

  defp current_refill_round(fundraiser_id) do
    loaded_fundraiser =
      Repo.get_by(Fundraiser, id: fundraiser_id)
      |> Repo.preload(:refill_rounds)

    Enum.find(loaded_fundraiser.refill_rounds, &(&1.closed_on == nil))
  end

  defp start_new_refill_round!(fundraiser) do
    pub(:refill_round_started) do
      Ecto.build_assoc(fundraiser, :refill_rounds)
      |> RefillRound.changeset(%{})
      |> Repo.insert!()
    end
  end

  defp payment_method(fundraiser_id, payment_service_name) do
    payment_service = Repo.get_by(PaymentService, name: payment_service_name)

    Repo.get_by(PaymentMethod,
      payment_service_id: payment_service.id,
      fundraiser_id: fundraiser_id
    )
  end
end
