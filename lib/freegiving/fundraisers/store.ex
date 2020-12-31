defmodule Freegiving.Fundraisers.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.Fundraiser

  schema "stores" do
    field :name, :string
    field :short_name, :string
    field :address, :string
    has_many :fundraisers, Fundraiser
    timestamps()
  end

  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :short_name, :address])
    |> validate_required([:name, :short_name, :address])
    |> validate_format(:short_name, ~r/^\w+$/)
    |> unique_constraint(:name)
    |> unique_constraint(:short_name)
  end
end
