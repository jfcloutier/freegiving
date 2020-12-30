defmodule Freegiving.Repo.Migrations.ContactRelationships do
  use Ecto.Migration

  def change do
    alter table("contacts") do
      remove :user_id
    end

    alter table("participants") do
      add :contact_id, references("contacts"), null: false
    end

    alter table("fundraiser_admins") do
      add :contact_id, references("contacts"), null: false
    end
  end
end
