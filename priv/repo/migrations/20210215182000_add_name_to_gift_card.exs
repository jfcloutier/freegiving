defmodule Freegiving.Repo.Migrations.AddNameToGiftCard do
  use Ecto.Migration

  def change do
    alter table("gift_cards") do
      add :name, :string, default: "My card", null: false
    end
  end
end
