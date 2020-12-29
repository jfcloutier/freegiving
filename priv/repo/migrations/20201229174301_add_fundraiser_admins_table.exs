defmodule Freegiving.Repo.Migrations.AddFundraiserAdminsTable do
  use Ecto.Migration

  def change do
    create table("fundraiser_admins") do
      add :contact_id, references("contacts")
      timestamps()
    end
  end
end
