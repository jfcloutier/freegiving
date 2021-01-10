defmodule Freegiving.Eventing do
  @moduledoc """
  Eventing support
  """

  defmacro __using__(_) do
    quote do
      import Freegiving.Eventing
    end
  end

  defmacro pub(channel, event_type, do: event_generator) do
    quote do
      case unquote(event_generator) do
        {:error, reason} ->
          {:error, reason}

        result ->
          Phoenix.PubSub.broadcast(
            Freegiving.PubSub,
            unquote(channel),
            {:event, unquote(event_type), de_okify(result)}
          )

          result
      end
    end
  end

  def publish(channel, event_type, payload) do
    Phoenix.PubSub.broadcast(
      Freegiving.PubSub,
      channel,
      {:event, event_type, payload}
    )
  end

  def de_okify({:ok, term}), do: term
  def de_okify(term), do: term
end
