defmodule Freegiving.Repo.Migrations.RemoveCardRefillRefFromPayments do
  use Ecto.Migration

  def change do
    alter table("payments") do
      remove :card_refill
    end
  end
end
