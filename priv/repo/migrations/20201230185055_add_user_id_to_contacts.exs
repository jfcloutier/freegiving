defmodule Freegiving.Repo.Migrations.AddUserIdToContacts do
  use Ecto.Migration

  def change do
    alter table("contacts") do
      add :user_id, references("users")
    end

    create index("contacts", :user_id)
  end
end
