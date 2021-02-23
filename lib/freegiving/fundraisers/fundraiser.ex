defmodule Freegiving.Fundraisers.Fundraiser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Freegiving.Fundraisers.{
    School,
    Store,
    RefillRound,
    Participant,
    FundraiserAdmin,
    Contact,
    GiftCard
  }

  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

  schema "fundraisers" do
    field :name, :string
    field :active, :boolean, default: true
    field :refill_round_min, :integer
    field :card_refill_max, :integer
    # How many unassigned gift cards left to request resupply
    field :card_reserve_low_mark, :integer, default: 0
    field :card_reserve_max, :integer, default: 50
    belongs_to :school, School
    belongs_to :store, Store
    belongs_to :store_contact, Contact
    has_many :gift_cards, GiftCard
    has_many :refill_rounds, RefillRound
    has_many :participants, Participant
    has_many :fundraiser_admins, FundraiserAdmin
    timestamps()
  end

  def changeset(fundraiser, attrs) do
    fundraiser
    |> cast(attrs, [
      :name,
      :refill_round_min,
      :card_refill_max,
      :active,
      :card_reserve_low_mark,
      :card_reserve_max
    ])
    |> validate_required([:name, :refill_round_min, :card_refill_max])
    |> validate_number(:refill_round_min, greater_than: 0)
    |> validate_number(:card_refill_max, greater_than: 0)
    |> validate_number(:card_reserve_low_mark, greater_than: 0)
    |> validate_number(:card_reserve_max, greater_than: 0)
    |> validate_reserve_bounds()
    |> unique_constraint(:name)
  end

  def make_fundraiser_active(fundraiser_id, active?) do
    Repo.get_by(Fundraiser, id: fundraiser_id)
    |> Fundraiser.changeset(%{active: active?})
    |> Repo.update()
  end

  def fundraiser_active?(fundraiser_id) do
    case Repo.get_by(Fundraiser, id: fundraiser_id) do
      nil -> false
      fundraiser -> fundraiser.active
    end
  end

  def fundraiser_active!(fundraiser_id) do
    fundraiser = Repo.get_by(Fundraiser, id: fundraiser_id)

    if fundraiser == nil or not fundraiser.active do
      raise("Not an active fundraiser")
    else
      :ok
    end
  end

  defp validate_reserve_bounds(changeset) do
    validate_change(changeset, :card_reserve_max, fn _field, value ->
      if value <= Ecto.Changeset.get_field(changeset, :card_reserve_low_mark) do
        [{:card_reserve_max, "must be greater than card_reserve_low_mark"}]
      else
        []
      end
    end)
  end
end
