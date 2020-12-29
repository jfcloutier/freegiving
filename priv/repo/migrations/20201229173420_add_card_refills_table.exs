defmodule Freegiving.Repo.Migrations.AddCardRefillsTable do
  use Ecto.Migration

  def change do
    create table("card_refills") do
      add :refill_round_id, references("refill_rounds"), null: false
      add :gift_card_id, references("gift_cards"), null: false
      add :amount, :integer, null: false
    end

    create index("card_refills", :refill_round_id)
    create index("card_refills", :gift_card_id)
  end
end
