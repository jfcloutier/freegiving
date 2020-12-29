defmodule Freegiving.Repo.Migrations.AddParticipantsTable do
  use Ecto.Migration

  def change do
    create table("participants") do
      add :user_id, references("users"), null: false
      add :fundraiser_id, references("fundraisers"), null: false
      timestamps()
    end

    create index("participants", :user_id)
    create index("participants", :fundraiser_id)
  end
end
