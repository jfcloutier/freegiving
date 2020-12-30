defmodule Freegiving.Fundraisers.PaymentService do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.PaymentMethod

  schema "payment_services" do
    field :name, :string
    field :url, :string
    has_many :payment_methods, PaymentMethod
    timestamps()
  end

  def payment_method_changeset(payment_method, attrs) do
    payment_method
    |> cast(attrs, [:name, :url])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
