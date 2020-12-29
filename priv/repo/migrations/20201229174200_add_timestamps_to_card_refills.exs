defmodule Freegiving.Repo.Migrations.AddTimestampsToCardRefills do
  use Ecto.Migration

  def change do
    alter table("card_refills") do
      timestamps()
    end
  end
end
