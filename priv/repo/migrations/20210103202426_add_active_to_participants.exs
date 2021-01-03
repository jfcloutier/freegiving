defmodule Freegiving.Repo.Migrations.AddActiveToParticipants do
  use Ecto.Migration

  def change do
    alter table("participants") do
      add :active, :boolean, default: true
    end
  end
end
