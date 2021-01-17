defmodule Freegiving.Repo.Migrations.AddPrimaryToFundraiserAdmins do
  use Ecto.Migration

  def change do
    alter table("fundraiser_admins") do
      add :primary, :boolean, default: false
    end
  end
end
