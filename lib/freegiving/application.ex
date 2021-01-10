defmodule Freegiving.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Freegiving.Repo,
      # Start the Telemetry supervisor
      FreegivingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Freegiving.PubSub},
      # Start the event handler
      Freegiving.EventHandler,
      # Start the Endpoint (http/https)
      FreegivingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Freegiving.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FreegivingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
