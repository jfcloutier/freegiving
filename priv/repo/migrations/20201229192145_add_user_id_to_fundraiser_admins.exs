defmodule Freegiving.Repo.Migrations.AddUserIdToFundraiserAdmins do
  use Ecto.Migration

  def change do
    alter table("fundraiser_admins") do
      add :user_id, references("users"), null: false
    end

    create index("fundraiser_admins", :user_id)
  end
end
