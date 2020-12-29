defmodule Freegiving.Repo.Migrations.AddFundraisersTable do
  use Ecto.Migration

  def change do
    create table("fundraisers") do
      add :school_id, references("schools"), null: false
      add :store_id, references("stores"), null: false
      add :refill_round_min, :integer, default: 1000
      timestamps()
    end

    create index("fundraisers", :school_id)
    create index("fundraisers", :store_id)
  end
end
