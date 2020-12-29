defmodule Freegiving.Repo.Migrations.AddSchoolTable do
  use Ecto.Migration

  def change do
    create table("schools") do
      add :name, :string, null: false
      add :address, :string, null: false
      timestamps()
    end

    create unique_index("schools", :name)
  end
end
