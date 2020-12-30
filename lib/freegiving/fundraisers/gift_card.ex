defmodule Freegiving.Fundraisers.GiftCard do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Participant, CardRefill}

  schema "gift_cards" do
    field :card_number, :string
    belongs_to :participant, Participant
    has_many :card_refills, CardRefill
    timestamps()
  end

  @spec gift_card_changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def gift_card_changeset(gift_card, attrs) do
    gift_card
    |> cast(attrs, [:card_number])
    |> validate_required([:card_number])
    |> unique_constraint(:card_number)
  end
end
