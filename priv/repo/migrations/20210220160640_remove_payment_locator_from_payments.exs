defmodule Freegiving.Repo.Migrations.RemovePaymentLocatorFromPayments do
  use Ecto.Migration

  def change do
    alter table("payments") do
      remove :payment_locator
    end
  end
end
