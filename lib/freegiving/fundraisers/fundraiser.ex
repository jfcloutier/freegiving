defmodule Freegiving.Fundraisers.Fundraiser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.{School, Store}

  schema "fundraisers" do
    field :refill_round_min, :integer
    belongs_to :school, School
    belongs_to :store, Store
    timestamps()
  end

  def fundraiser_changerset(fundraiser, attrs) do
    fundraiser
    |> cast(attrs, [:refill_round_min])
    |> validate_required([:refill_round_min])
    |> validate_number(:refill_round_min, greater_than: 0)
  end
end
