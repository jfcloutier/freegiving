defmodule Freegiving.Repo.Migrations.CreatePaymentNotifications do
  use Ecto.Migration

  def change do
    create table("payment_notifications") do
      add :amount, :integer, null: false
      add :paid_from_email, :string, null: false
      add :paid_to_email, :string, null: false
      add :payment_note, :string, null: false
      add :payment_locator, :string, null: false
      timestamps()
    end

    create index("payment_notifications", [:paid_from_email, :paid_to_email])
  end
end
