defmodule Freegiving.Fundraisers.GiftCard do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.Participant

  schema "gift_cards" do
    field :card_number, :string
    belongs_to :participant, Participant
    timestamps()
  end

  def gift_card_changeset(gift_card, attrs) do
    gift_card
    |> cast(attrs, [:card_number])
    |> unique_constraint(:card_number)
  end
end
