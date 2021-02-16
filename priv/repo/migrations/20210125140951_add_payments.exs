defmodule Freegiving.Repo.Migrations.AddPayments do
  use Ecto.Migration

  def change do
    create table("payments") do
      add :amount, :integer, null: false
      add :payment_method, references("payment_methods"), null: false
      add :payment_locator, :string, null: false
      add :card_refill, references("card_refills"), null: false
    end
  end
end
