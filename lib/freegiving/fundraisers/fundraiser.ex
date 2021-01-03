defmodule Freegiving.Fundraisers.Fundraiser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.{School, Store, RefillRound, Participant, FundraiserAdmin, Contact}

  schema "fundraisers" do
    field :name, :string
    field :active, :boolean, default: true
    field :refill_round_min, :integer
    field :card_refill_max, :integer
    belongs_to :school, School
    belongs_to :store, Store
    belongs_to :store_contact, Contact
    has_many :refill_rounds, RefillRound
    has_many :participants, Participant
    has_many :fundraiser_admins, FundraiserAdmin
    timestamps()
  end

  def changeset(fundraiser, attrs) do
    fundraiser
    |> cast(attrs, [:name, :refill_round_min, :card_refill_max, :active])
    |> validate_required([:name, :refill_round_min, :card_refill_max])
    |> validate_number(:refill_round_min, greater_than: 0)
    |> validate_number(:card_refill_max, greater_than: 0)
    |> unique_constraint(:name)
  end
end
