defmodule Freegiving.Fundraisers.GiftCard do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, Participant, CardRefill}
  alias Freegiving.Repo

  # A gift card always belongs to a fundraiser and my also belong to a participant in that fundraiser
  # A gift card that does not bleong to a particpant is in the "gift cards reserve" of the fundraiser
  # Gift cards are allocated to participants of a fundraiser from its card reserve
  schema "gift_cards" do
    field :card_number, :string
    field :active, :boolean, default: false
    belongs_to :participant, Participant
    belongs_to :fundraiser, Fundraiser
    has_many :card_refills, CardRefill
    timestamps()
  end

  def changeset(gift_card, attrs) do
    gift_card
    |> cast(attrs, [:card_number, :active])
    |> validate_required([:card_number])
    |> unique_constraint(:card_number)
    |> validate_assigned_participant()
  end

  defp validate_assigned_participant(changeset) do
    validate_change(changeset, :participant_id, fn _field, participant_id ->
      if participant_id != nil do
        participant = Repo.get_by(Participant, :participant_id)
        fundraiser_id = Ecto.Changeset.get_field(changeset, :fundraiser_id)

        if participant.fundraiser_id != fundraiser_id do
          [
            {:participant_id,
             "must reference a participant in the gift card's fundraiser (#{fundraiser_id})"}
          ]
        else
          []
        end
      else
        []
      end
    end)
  end
end
