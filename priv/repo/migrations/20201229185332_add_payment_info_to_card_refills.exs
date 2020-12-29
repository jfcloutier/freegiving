defmodule Freegiving.Repo.Migrations.AddPaymentInfoToCardRefills do
  use Ecto.Migration

  def change do
    alter table("card_refills") do
      add :payment_method_id, references("payment_methods"), null: false
      add :payment_locator, :string, null: false
    end

    create index("card_refills", :payment_method_id)
  end
end
