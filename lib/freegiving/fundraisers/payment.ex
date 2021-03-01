defmodule Freegiving.Fundraisers.Payment do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{CardRefill, PaymentMethod, PaymentNotification}
  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

  schema "payments" do
    field :amount, :integer
    belongs_to :payment_method, PaymentMethod
    belongs_to :payment_notification, PaymentNotification
    has_one :card_refill, CardRefill
    timestamps()
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than: 0)
  end

  def register_payment(attrs, payment_notification_id: payment_notification_id) do
    pub(:added) do
      %Payment{payment_notification_id: payment_notification_id}
      |> Payment.changeset(attrs)
      |> Repo.insert()
    end
  end
end
