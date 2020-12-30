defmodule Freegiving.Repo.Migrations.AddShortNameToStores do
  use Ecto.Migration

  def change do
    alter table("stores") do
      add :short_name, :string, null: false
    end

    create unique_index("stores", :short_name)
  end
end
