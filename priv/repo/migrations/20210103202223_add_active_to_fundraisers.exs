defmodule Freegiving.Repo.Migrations.AddActiveToFundraisers do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      add :active, :boolean, default: true
    end
  end
end
