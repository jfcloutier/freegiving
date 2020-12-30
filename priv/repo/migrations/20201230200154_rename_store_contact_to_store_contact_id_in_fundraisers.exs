defmodule Freegiving.Repo.Migrations.RenameStoreContactToStoreContactIdInFundraisers do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      remove :store_contact
      add :store_contact_id, references("contacts"), null: false
    end
  end
end
