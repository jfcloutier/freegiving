defmodule Freegiving.Repo.Migrations.RemoveNullTrueForParticipantIdInGiftCards do
  use Ecto.Migration

  def change do
    alter table("gift_cards") do
      remove :participant_id
      add :participant_id, references("participants")
    end
  end
end
