defmodule Freegiving.Repo.Migrations.AddNameToFundraisers do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      add :name, :string, null: false
    end

    create unique_index("fundraisers", :name)
  end
end
