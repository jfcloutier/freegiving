defmodule Freegiving.Repo.Migrations.AddGiftCardsTable do
  use Ecto.Migration

  def change do
    create table("gift_cards") do
      add :participant_id, references("participants"), null: false
      add :card_number, :string, null: false
      timestamps()
    end
  end
end
