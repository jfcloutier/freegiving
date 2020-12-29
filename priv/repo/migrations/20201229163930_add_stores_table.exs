defmodule Freegiving.Repo.Migrations.AddStoresTable do
  use Ecto.Migration

  def change do
    create table("stores") do
      add :name, :string, null: false
      add :address, :string, null: false
      timestamps()
    end

    create unique_index("stores", :name)
  end
end
