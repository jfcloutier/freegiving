defmodule Freegiving.Fundraisers.FundraiserAdmin do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, Contact}
  alias Freegiving.Accounts.User

  schema "fundraiser_admins" do
    belongs_to :contact, Contact
    belongs_to :fundraiser, Fundraiser
    belongs_to :user, User
    timestamps()
  end
end
