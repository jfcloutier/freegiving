defmodule Freegiving.Fundraisers.Fundraiser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.{School, Store, RefillRound, Participant, FundraiserAdmin, Contact}

  schema "fundraisers" do
    field :refill_round_min, :integer
    belongs_to :school, School
    belongs_to :store, Store
    belongs_to :store_contact, Contact
    has_many :refill_rounds, RefillRound
    has_many :participants, Participant
    has_many :fundraiser_admins, FundraiserAdmin
    timestamps()
  end

  def fundraiser_changeset(fundraiser, attrs) do
    fundraiser
    |> cast(attrs, [:refill_round_min])
    |> validate_required([:refill_round_min])
    |> validate_number(:refill_round_min, greater_than: 0)
  end
end
