defmodule Freegiving.Fundraisers.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.Fundraiser
  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

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

  def register_store(attrs) do
    pub(:added) do
      %Store{}
      |> Store.changeset(attrs)
      |> Repo.insert()
    end
  end
end
