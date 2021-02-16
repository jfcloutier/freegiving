defmodule Freegiving.Fundraisers.GiftCard do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, Participant, CardRefill}
  alias Freegiving.Repo
  alias __MODULE__

  # A gift card always belongs to a fundraiser and my also belong to a participant in that fundraiser
  # A gift card that does not bleong to a particpant is in the "gift cards reserve" of the fundraiser
  # Gift cards are allocated to participants of a fundraiser from its card reserve
  schema "gift_cards" do
    field :card_number, :string
    field :active, :boolean, default: false
    field :name, :string, default: "My card"
    belongs_to :participant, Participant
    belongs_to :fundraiser, Fundraiser
    has_many :card_refills, CardRefill
    timestamps()
  end

  def changeset(gift_card, attrs) do
    gift_card
    |> cast(attrs, [:card_number, :active, :name])
    |> validate_required([:card_number])
    |> unique_constraint(:card_number)
    |> validate_assigned_participant()
    |> validate_name_unique_to_participant()
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

  defp validate_name_unique_to_participant(changeset) do
    validate_change(changeset, :name, fn _field, name ->
      participant_id = Ecto.Changeset.get_field(changeset, :participant_id)

      if participant_id != nil do
        count =
          from(GiftCard, where: [participant_id: ^participant_id, name: ^name])
          |> Repo.all()
          |> Enum.count()

        if count > 0 do
          [{:name, "the name \"#{name}\" is already taken"}]
        else
          []
        end
      else
        []
      end
    end)
  end
end
