defmodule Freegiving.Repo.Migrations.AllowNullPaymentLocatorInCardRefills do
  use Ecto.Migration

  def change do
    alter table("card_refills") do
      remove :payment_locator
      add :payment_locator, :string, null: true
    end
  end
end
