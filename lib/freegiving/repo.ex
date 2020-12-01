defmodule Freegiving.Repo do
  use Ecto.Repo,
    otp_app: :freegiving,
    adapter: Ecto.Adapters.Postgres
end
