defmodule Freegiving.Repo.Migrations.AddPaidByToPaymentNotifications do
  use Ecto.Migration

  def change do
    alter table("payment_notifications") do
      add :paid_by, :string, null: false
    end
  end
end
