defmodule Freegiving.Repo.Migrations.AddPaymentMethodsTable do
  use Ecto.Migration

  def change do
    create table("payment_methods") do
      add :payment_service_id, references("payment_services"), null: false
      add :fundraiser_id, references("fundraisers"), null: false
      add :payable_to, :string, null: false
      timestamps()
    end

    create index("payment_methods", :payment_service_id)
    create index("payment_methods", :fundraiser_id)
  end
end
