defmodule Freegiving.Fundraisers.Contact do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, Participant, FundraiserAdmin}

  schema "contacts" do
    field :name, :string, null: false
    field :email, :string, null: false
    field :phone, :string, null: false
    has_many :store_contacts, Fundraiser, foreign_key: :store_contact_id
    has_many :participants, Participant
    has_many :fundraiser_admins, FundraiserAdmin
    timestamps()
  end

  def contact_changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :phone])
    |> validate_required([:name, :email, :phone])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_format(:phone, ~r/^\d\d\d-\d\d\d-\d\d\d\d$/,
      message: "must look like 207-555-1212"
    )
    |> unique_constraint(:email)
  end
end
