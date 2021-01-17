defmodule Freegiving.Fundraisers.FundraiserAdmin do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, Contact}
  alias Freegiving.Accounts.User

  schema "fundraiser_admins" do
    field :primary, :boolean, default: true
    belongs_to :contact, Contact
    belongs_to :fundraiser, Fundraiser
    belongs_to :user, User
    timestamps()
  end

  def changeset(fundraiser_admin, attrs) do
    fundraiser_admin
    |> cast(attrs, [:primary])
  end
end
