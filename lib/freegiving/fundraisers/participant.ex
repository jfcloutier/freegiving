defmodule Freegiving.Fundraisers.Participant do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, GiftCard, Preference}
  alias Freegiving.Accounts.User

  schema "participants" do
    belongs_to :fundraiser, Fundraiser
    belongs_to :user, User
    has_many :gift_cards, GiftCard
    has_one :preference, Preference
    timestamps()
  end
end
