defmodule Freegiving.Eventing do
  @moduledoc """
  Eventing support
  """

  defmacro __using__(_) do
    quote do
      import Freegiving.Eventing
    end
  end

  defmacro pub(event_type, do: event_generator) do
    quote do
      case unquote(event_generator) do
        {:error, reason} ->
          {:error, reason}

        result ->
          publish(unquote(event_type), result)
          result
      end
    end
  end

  def publish(event_type, payload) do
    # Each event is responded to in its own process
    spawn_link(fn ->
      Phoenix.PubSub.broadcast(
        Freegiving.PubSub,
        "freegiving",
        {:event, event_type, de_okify(payload)}
      )
    end)
  end

  defp de_okify({:ok, term}), do: term
  defp de_okify(term), do: term
end
