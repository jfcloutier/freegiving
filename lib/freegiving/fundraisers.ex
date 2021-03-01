defmodule Freegiving.Fundraisers do
  @moduledoc "The Fundraisers context - CRUD"

  import Ecto.Query, warn: false
  alias Freegiving.Repo
  alias Freegiving.Fundraisers.{School}
  require Logger

  use Freegiving.Eventing

  alias Freegiving.Fundraisers.{
    School,
    Store,
    Contact,
    Fundraiser,
    Participant,
    GiftCard,
    RefillRound,
    CardRefill,
    FundraiserAdmin
  }

  alias Freegiving.Accounts.User

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

          RefillRound.start_new_refill_round!(fundraiser)

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
          case Contact.register_contact_if_new(contact_attrs) do
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
        {:ok, contact} = Contact.register_contact_if_new(contact_attrs)

        %FundraiserAdmin{fundraiser_id: fundraiser.id, user_id: user.id, contact_id: contact.id}
        |> FundraiserAdmin.changeset(%{primary: primary?})
        |> Repo.insert!()
      end)
    end
  end

  # attrs contains name, else name defaults to "My gift card"
  def assign_gift_card(attrs, participant_id: participant_id) do
    pub(:gift_card_assigned) do
      Repo.transaction(fn ->
        participant = Repo.get_by!(Participant, id: participant_id)

        case Repo.all(
               from gc in "gift_cards",
                 where: gc.fundraiser_id == ^participant.fundraiser_id,
                 where: is_nil(gc.participant_id),
                 select: [:card_number]
             ) do
          [] ->
            reason =
              "All gift cards for fundraiser #{participant.fundraiser_id} have been assigned"

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

  def request_card_refill(attrs,
        card_number: card_number
      ) do
    pub(:added) do
      Repo.transaction(fn ->
        gift_card = Repo.get_by!(GiftCard, card_number: card_number)
        gift_card_participant_active!(gift_card)
        card_refill_with_fundraiser = Repo.preload(gift_card, :fundraiser)
        fundraiser_id = card_refill_with_fundraiser.fundraiser.id
        Fundraiser.fundraiser_active!(fundraiser_id)
        current_refill_round = current_refill_round!(fundraiser_id)

        %CardRefill{
          gift_card_id: gift_card.id,
          refill_round_id: current_refill_round.id
        }
        |> CardRefill.changeset(attrs)
        |> Repo.insert!()
      end)
    end
  end

  def current_refill_round!(fundraiser_id) do
    loaded_fundraiser =
      Repo.get_by!(Fundraiser, id: fundraiser_id)
      |> Repo.preload(:refill_rounds)

    case Enum.find(loaded_fundraiser.refill_rounds, &(&1.closed_on == nil)) do
      nil -> raise "All refill rounds are closed"
      refill_round -> refill_round
    end
  end

  ### PRIVATE

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
end
