defmodule Freegiving.Fundraisers.PaymentService do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.PaymentMethod
  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

  schema "payment_services" do
    field :name, :string
    field :url, :string
    field :email_domain, :string
    has_many :payment_methods, PaymentMethod
    timestamps()
  end

  def changeset(payment_method, attrs) do
    payment_method
    |> cast(attrs, [:name, :url, :email_domain])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def register_payment_service(attrs) do
    pub(:added) do
      %PaymentService{}
      |> PaymentService.changeset(attrs)
      |> Repo.insert()
    end
  end

  def from_email(email) do
    with [_, domain] <- String.split(email, "@") do
      case Repo.get_by(PaymentService, email_domain: domain) do
        nil -> {:error, :not_found}
        payment_service -> {:ok, payment_service}
      end
    end
  end
end
