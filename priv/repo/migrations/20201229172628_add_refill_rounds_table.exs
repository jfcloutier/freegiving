defmodule Freegiving.Repo.Migrations.AddRefillRoundsTable do
  use Ecto.Migration

  def change do
    create table("refill_rounds") do
      add :fundraiser_id, references("fundraisers"), null: false
      add :closed_on, :naive_datetime
      add :executed_on, :naive_datetime
      timestamps()
    end
  end
end
