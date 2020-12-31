defmodule Freegiving.Fundraisers.CardRefill do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{GiftCard, RefillRound, PaymentMethod}

  schema "card_refills" do
    field :amount, :integer
    belongs_to :gift_card, GiftCard
    belongs_to :refill_round, RefillRound
    belongs_to :payment_method, PaymentMethod
    timestamps()
  end

  def changeset(card_refill, attrs) do
    card_refill
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
  end
end
