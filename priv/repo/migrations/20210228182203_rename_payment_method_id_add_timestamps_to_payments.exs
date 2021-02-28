defmodule Freegiving.Repo.Migrations.RenamePaymentMethodIdAddTimestampsToPayments do
  use Ecto.Migration

  def change do
    alter table("payments") do
      remove :payment_method
      add :payment_method_id, references("payment_methods")
      timestamps()
    end
  end
end
