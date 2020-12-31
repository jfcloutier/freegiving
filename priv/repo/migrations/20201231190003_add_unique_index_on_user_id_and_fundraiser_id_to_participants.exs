defmodule Freegiving.Repo.Migrations.AddUniqueIndexOnUserIdAndFundraiserIdToParticipants do
  use Ecto.Migration

  def change do
    create index("participants", [:user_id, :fundraiser_id], unique: true)
  end
end
