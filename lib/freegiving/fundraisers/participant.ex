defmodule Freegiving.Fundraisers.Participant do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, GiftCard, Contact}
  alias Freegiving.Accounts.User

  schema "participants" do
    field :notify_by_email, :boolean
    field :notify_by_text, :boolean
    field :active, :boolean, default: true
    belongs_to :fundraiser, Fundraiser
    belongs_to :user, User
    belongs_to :contact, Contact
    has_many :gift_cards, GiftCard, on_replace: :nilify
    timestamps()
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:active, :notify_by_email, :notify_by_text])
    |> unique_constraint([:user_id, :fundraiser_id],
      message: "A user can participate only one in a given fundraiser"
    )
  end
end
