defmodule Freegiving.Fundraisers.RefillRound do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.{CardRefill, Fundraiser}
  alias __MODULE__
  use Freegiving.Eventing
  alias Freegiving.Repo

  schema "refill_rounds" do
    # when round closed
    field :closed_on, :naive_datetime
    # when all cards in round were refilled
    field :executed_on, :naive_datetime
    belongs_to :fundraiser, Fundraiser
    has_many :card_refills, CardRefill
    timestamps()
  end

  def changeset(refill_round, attrs) do
    refill_round
    |> cast(attrs, [:closed_on, :executed_on])
  end

  def start_new_refill_round!(fundraiser) do
    pub(:refill_round_started) do
      Ecto.build_assoc(fundraiser, :refill_rounds)
      |> RefillRound.changeset(%{})
      |> Repo.insert!()
    end
  end
end
