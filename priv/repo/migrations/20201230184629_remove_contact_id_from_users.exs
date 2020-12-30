defmodule Freegiving.Repo.Migrations.RemoveContactIdFromUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      remove :contact_id
    end
  end
end
