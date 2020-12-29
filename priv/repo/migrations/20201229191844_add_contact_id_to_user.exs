defmodule Freegiving.Repo.Migrations.AddContactIdToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :contact_id, references("contacts")
    end
  end
end
