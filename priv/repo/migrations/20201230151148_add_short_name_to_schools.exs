defmodule Freegiving.Repo.Migrations.AddShortNameToSchools do
  use Ecto.Migration

  def change do
    alter table("schools") do
      add :short_name, :string, null: false
    end

    create unique_index("schools", :short_name)
  end
end
