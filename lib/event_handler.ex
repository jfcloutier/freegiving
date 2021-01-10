defmodule Freegiving.EventHandler do
  @moduledoc """
  Freegiving event handler
  """

  use GenServer
  alias Phoenix.PubSub
  require Logger

  @pubsub_channels ~w(crud app)

  def start_link(_) do
    GenServer.start(__MODULE__, nil)
  end

  ### CALLBACKS

  def init(_) do
    subscribe_all(@pubsub_channels)
    {:ok, %{}}
  end

  def handle_info({:event, {_event_type, _payload} = event}, state) do
    Logger.info("Handling event #{inspect(event)}")
    {:noreply, state}
  end

  def handle_info(info, state) do
    Logger.info("IGNORING INFO #{inspect(info)}")
    {:noreply, state}
  end

  ### Private

  defp subscribe_all(channels) do
    Enum.each(channels, &PubSub.subscribe(Freegiving.PubSub, &1))
  end
end
