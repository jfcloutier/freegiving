defmodule Freegiving.Repo.Migrations.AddCardReserveMaxToFundraiser do
  use Ecto.Migration

  def change do
    alter table("fundraisers") do
      add :card_reserve_max, :integer, default: 50
    end
  end
end
