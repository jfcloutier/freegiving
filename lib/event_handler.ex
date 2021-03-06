defmodule Freegiving.EventHandler do
  @moduledoc """
  Freegiving event handler
  """

  use GenServer
  alias Phoenix.PubSub
  alias Freegiving.Services.{RefillRoundService, GiftCardService, MishapService}
  require Logger

  def start_link(_) do
    GenServer.start(__MODULE__, nil)
  end

  ### CALLBACKS

  def init(_) do
    PubSub.subscribe(Freegiving.PubSub, "freegiving")
    {:ok, %{}}
  end

  def handle_info({:event, :refill_round_closed, refill_round}, state) do
    RefillRoundService.refill_round_closed(refill_round)
    {:noreply, state}
  end

  def handle_info({:event, :gift_card_assigned, gift_card}, state) do
    GiftCardService.gift_card_assigned(gift_card)
    {:noreply, state}
  end

  def handle_info({:event, :mishap, mishap}, state) do
    MishapService.report_mishap(mishap)
    {:noreply, state}
  end

  def handle_info({:event, _event_type, _payload} = event, state) do
    Logger.info("IGNORING EVENT #{inspect(event)}")
    {:noreply, state}
  end

  def handle_info(info, state) do
    Logger.info("IGNORING INFO #{inspect(info)}")
    {:noreply, state}
  end
end
