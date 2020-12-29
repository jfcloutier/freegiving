defmodule Freegiving.Repo.Migrations.AddTimestampsToContacts do
  use Ecto.Migration

  def change do
    alter table("contacts") do
      timestamps()
    end
  end
end
