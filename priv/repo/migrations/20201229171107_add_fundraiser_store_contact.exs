defmodule Freegiving.Repo.Migrations.AddFundraiserStoreContact do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      add :store_contact, references("contacts")
    end
  end
end
