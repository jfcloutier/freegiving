defmodule Freegiving.Repo.Migrations.DropPreferencesTable do
  use Ecto.Migration

  def change do
    drop table("preferences")
  end
end
