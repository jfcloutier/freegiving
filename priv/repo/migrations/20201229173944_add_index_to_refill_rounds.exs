defmodule Freegiving.Repo.Migrations.AddIndexToRefillRounds do
  use Ecto.Migration

  def change do
    create index("refill_rounds", :fundraiser_id)
  end
end
