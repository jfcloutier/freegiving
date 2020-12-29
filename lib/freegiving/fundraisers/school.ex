defmodule Freegiving.Fundraisers.School do
  use Ecto.Schema
  import Ecto.Changeset
  alias Freegiving.Fundraisers.Fundraiser

  schema "schools" do
    field :name, :string
    field :address, :string
    has_many :fundraisers, Fundraiser
    timestamps()
  end

  def school_changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
    |> unique_constraint(:name)
  end
end
