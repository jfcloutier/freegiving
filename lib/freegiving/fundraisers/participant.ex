defmodule Freegiving.Fundraisers.Participant do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  import Ecto.Query, warn: false
  alias Freegiving.Fundraisers.{Fundraiser, GiftCard, Contact}
  alias Freegiving.Accounts.User
  alias Freegiving.Repo
  alias __MODULE__

  schema "participants" do
    field :notify_by_email, :boolean
    field :notify_by_text, :boolean
    field :active, :boolean, default: true
    belongs_to :fundraiser, Fundraiser
    belongs_to :user, User
    belongs_to :contact, Contact
    has_many :gift_cards, GiftCard
    timestamps()
  end

  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:active, :notify_by_email, :notify_by_text])
    |> unique_constraint([:user_id, :fundraiser_id],
      message: "A user can participate only once in a given fundraiser"
    )
  end

  def get_participant(fundraiser_name: fundraiser_name, user_email: user_email) do
    query =
      from p in Participant,
        join: f in Fundraiser,
        on: p.fundraiser_id == f.id,
        join: u in User,
        on: p.user_id == u.id,
        where: f.name == ^fundraiser_name,
        where: u.email == ^user_email,
        select: p.id

    case Repo.one(query) do
      nil ->
        nil

      participant_id ->
        Repo.get_by(Participant, id: participant_id)
        |> Repo.preload(:gift_cards)
        |> Repo.preload(:contact)
    end
  end

  def make_participant_active(participant_id, active?) do
    Repo.get_by(Participant, id: participant_id)
    |> Participant.changeset(%{active: active?})
    |> Repo.update()
  end

  def participant_active?(participant_id) do
    case Repo.get_by(Participant, id: participant_id) do
      nil -> false
      participant -> participant.active
    end
  end
end
