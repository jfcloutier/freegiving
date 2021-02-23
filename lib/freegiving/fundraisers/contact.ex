defmodule Freegiving.Fundraisers.Contact do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, Participant, FundraiserAdmin}
  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

  schema "contacts" do
    field :name, :string, null: false
    field :email, :string, null: false
    field :phone, :string, null: false
    field :address, :string
    has_many :store_contacts, Fundraiser, foreign_key: :store_contact_id
    has_many :participants, Participant
    has_many :fundraiser_admins, FundraiserAdmin
    timestamps()
  end

  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :phone, :address])
    |> validate_required([:name, :email, :phone])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_format(:phone, ~r/^\d\d\d-\d\d\d-\d\d\d\d$/,
      message: "must look like 207-555-1212"
    )
    |> unique_constraint(:email)
  end

  def register_contact(attrs) do
    pub(:added) do
      %Contact{}
      |> Contact.changeset(attrs)
      |> Repo.insert()
    end
  end

  def register_contact_if_new(%{email: email} = attrs) do
    case Repo.get_by(Contact, email: email) do
      nil ->
        register_contact(attrs)

      contact ->
        {:ok, contact}
    end
  end
end
