defmodule Freegiving.Fundraisers.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.Fundraiser

  schema "stores" do
    field :name, :string
    field :address, :string
    has_many :fundraisers, Fundraiser
    timestamps()
  end

  def store_changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
    |> unique_constraint(:name)
  end
end
