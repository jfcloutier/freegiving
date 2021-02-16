defmodule Freegiving.Fundraisers.PaymentNotification do
  use Ecto.Schema
  import Ecto.Changeset, warn: false

  schema "payment_notifications" do
    field :amount, :integer
    field :paid_from_email, :string
    field :paid_to_email, :string
    field :payment_note, :string
    field :payment_locator, :string
    timestamps()
  end

  def changeset(payment_notification, attrs) do
    payment_notification
    |> cast(attrs, [:amount, :paid_from_email, :paid_to_email, :payment_note, :payment_locator])
    |> validate_required([
      :amount,
      :paid_from_email,
      :paid_to_email,
      :payment_note,
      :payment_locator
    ])
    |> validate_number(:amount, greater_than: 0)
  end
end
