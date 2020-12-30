defmodule Freegiving.Repo.Migrations.AddFundraiserToFundraiserAdmins do
  use Ecto.Migration

  def change do
    alter table("fundraiser_admins") do
      add :fundraiser_id, references("fundraisers"), null: false
    end

    create index("fundraiser_admins", :fundraiser_id)
  end
end
