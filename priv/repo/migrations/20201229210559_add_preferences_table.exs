defmodule Freegiving.Repo.Migrations.AddPreferencesTable do
  use Ecto.Migration

  def change do
    create table("preferences") do
      add :participant_id, references("participants"), null: false
      add :notify_via_email, :boolean, default: true
      add :notify_via_text, :boolean, default: false
    end

    create index("preferences", :participant_id)
  end
end
