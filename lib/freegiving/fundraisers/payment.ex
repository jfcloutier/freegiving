defmodule Freegiving.Fundraisers.Payment do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{CardRefill, PaymentMethod}

  schema "payments" do
    field :amount, :integer
    field :payment_locator, :string
    belongs_to :card_refill, CardRefill
    belongs_to :payment_method, PaymentMethod
    timestamps()
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :payment_locator])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
