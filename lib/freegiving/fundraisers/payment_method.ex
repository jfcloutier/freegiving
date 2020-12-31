defmodule Freegiving.Fundraisers.PaymentMethod do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{CardRefill, PaymentService, Fundraiser}

  schema "payment_methods" do
    field :payable_to, :string
    belongs_to :fundraiser, Fundraiser
    has_many :card_refills, CardRefill
    belongs_to :payment_service, PaymentService
    timestamps()
  end

  def changeset(payment_method, attrs) do
    payment_method
    |> cast(attrs, [:payable_to])
    |> validate_required([:payable_to])
  end
end
