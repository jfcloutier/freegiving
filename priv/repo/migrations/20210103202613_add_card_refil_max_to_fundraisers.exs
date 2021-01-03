defmodule Freegiving.Repo.Migrations.AddCardRefilMaxToFundraisers do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      add :card_refill_max, :integer, null: false
    end
  end
end
