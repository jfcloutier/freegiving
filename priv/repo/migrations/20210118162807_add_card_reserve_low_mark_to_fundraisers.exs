defmodule Freegiving.Repo.Migrations.AddCardReserveLowMarkToFundraisers do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      add :card_reserve_low_mark, :integer, default: 0
    end
  end
end
