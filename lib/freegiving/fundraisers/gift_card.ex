defmodule Freegiving.Fundraisers.GiftCard do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Participant, CardRefill}

  schema "gift_cards" do
    field :card_number, :string
    belongs_to :participant, Participant
    has_many :card_refills, CardRefill
    has_one :fundraiser, through: [:participant, :fundraiser]
    timestamps()
  end

  def changeset(gift_card, attrs) do
    gift_card
    |> cast(attrs, [:card_number])
    |> validate_required([:card_number])
    |> unique_constraint(:card_number)
  end
end
