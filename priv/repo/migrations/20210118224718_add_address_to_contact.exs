defmodule Freegiving.Repo.Migrations.AddAddressToContact do
  use Ecto.Migration

  def change do
    alter table("contacts") do
      add :address, :string
    end
  end
end
