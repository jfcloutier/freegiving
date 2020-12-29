defmodule Freegiving.Fundraisers.Preference do
  use Ecto.Schema
  import Ecto.Changeset, warn: false
  alias Freegiving.Fundraisers.Participant

  schema "preferences" do
    field :notify_by_email, :boolean
    field :notify_by_text, :boolean
    belongs_to :participant, Participant
    timestamps()
  end

  def preference_changeset(preference, attrs) do
    preference
    |> cast(attrs, [:notify_by_email, :notify_by_text])
  end
end
