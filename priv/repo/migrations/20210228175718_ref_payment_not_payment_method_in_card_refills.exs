defmodule Freegiving.Repo.Migrations.RefPaymentNotPaymentMethodInCardRefills do
  use Ecto.Migration

  def change do
    drop index("card_refills", [:payment_method_id])

    alter table("card_refills") do
      remove :payment_method_id
      add :payment_id, references("payments")
    end
  end
end
