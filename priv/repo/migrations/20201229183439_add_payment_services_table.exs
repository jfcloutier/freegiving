defmodule Freegiving.Repo.Migrations.AddPaymentServicesTable do
  use Ecto.Migration

  def change do
    create table("payment_services") do
      add :name, :string, null: false
      add :url, :string
      timestamps()
    end

    create index("payment_services", :name)
  end
end
