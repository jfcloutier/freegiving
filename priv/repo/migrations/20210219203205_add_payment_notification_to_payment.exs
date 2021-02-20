defmodule Freegiving.Repo.Migrations.AddPaymentNotificationToPayment do
  use Ecto.Migration

  def change do
    alter table("payments") do
      add :payment_notification_id, references("payment_notifications")
    end
  end
end
