defmodule Freegiving.Repo.Migrations.RemoveContactIdFromFundraiserAdmins do
  use Ecto.Migration

  def change do
    alter table("fundraiser_admins") do
      remove :contact_id
    end
  end
end
