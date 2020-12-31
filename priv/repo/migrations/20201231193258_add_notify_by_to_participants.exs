defmodule Freegiving.Repo.Migrations.AddNotifyByToParticipants do
  use Ecto.Migration

  def change do
    alter table("participants") do
      add :notify_by_email, :boolean, default: true
      add :notify_by_text, :boolean, default: false
    end
  end
end
