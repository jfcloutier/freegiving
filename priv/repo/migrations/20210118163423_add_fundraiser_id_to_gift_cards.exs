defmodule Freegiving.Repo.Migrations.AddFundraiserIdToGiftCards do
  use Ecto.Migration

  def change do
    alter table("gift_cards") do
      add :fundraiser_id, references("fundraisers"), null: false
      remove :participant_id
      add :participant_id, references("participants"), null: true
    end
  end
end
