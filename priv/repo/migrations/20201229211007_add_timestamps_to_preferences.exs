defmodule Freegiving.Repo.Migrations.AddTimestampsToPreferences do
  use Ecto.Migration

  def change do
    alter table("preferences") do
      timestamps()
    end
  end
end
