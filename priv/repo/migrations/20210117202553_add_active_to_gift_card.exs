defmodule Freegiving.Repo.Migrations.AddActiveToGiftCard do
  use Ecto.Migration

  def change do
    alter table("gift_cards") do
      add :active, :boolean, default: false
    end
  end
end
