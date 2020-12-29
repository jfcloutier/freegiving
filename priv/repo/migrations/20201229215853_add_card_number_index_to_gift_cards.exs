defmodule Freegiving.Repo.Migrations.AddCardNumberIndexToGiftCards do
  use Ecto.Migration

  def change do
    create unique_index("gift_cards", :card_number)
  end
end
