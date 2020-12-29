defmodule Freegiving.Repo.Migrations.AddContactsTable do
  use Ecto.Migration

  def change do
    create table("contacts") do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string
    end

    create unique_index("contacts", :email)
  end
end
