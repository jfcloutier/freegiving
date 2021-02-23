defmodule Freegiving.Fundraisers.PaymentMethod do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{CardRefill, PaymentService, Fundraiser}
  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

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

  def register_payment_method(attrs,
        fundraiser_id: fundraiser_id,
        payment_service_name: payment_service_name
      ) do
    pub(:added) do
      payment_service = Repo.get_by(PaymentService, name: payment_service_name)

      %PaymentMethod{fundraiser_id: fundraiser_id, payment_service_id: payment_service.id}
      |> PaymentMethod.changeset(attrs)
      |> Repo.insert()
    end
  end

  def payment_method(fundraiser_id, payment_service_name) do
    payment_service = Repo.get_by(PaymentService, name: payment_service_name)

    Repo.get_by(PaymentMethod,
      payment_service_id: payment_service.id,
      fundraiser_id: fundraiser_id
    )
  end
end
