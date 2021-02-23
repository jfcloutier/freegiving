defmodule Freegiving.Services.PaymentNotificationService do
  @moduledoc """
  Payment notification service.
  For each payment notification, try to create a payment for a card refill.
  """

  alias Freegiving.Mishap
  alias Freegiving.Services.MishapService
  alias Freegiving.Fundraisers.{PaymentService, Payment, PaymentNotification}
  require Logger

  @doc "Called when a payment has been received."
  #
  def payment_notified(
        amount: amount,
        # The email address the notification was sent from
        paid_from_email: paid_from_email,
        # the email address the notification was sent to
        paid_to_email: paid_to_email,
        # typically a full name mapping to a participant
        paid_by: paid_by,
        # should include a known grocery card name but may not
        payment_note: payment_note,
        # some unique transaction ID
        payment_locator: payment_locator
      ) do
    # store in payment_notifications
    {:ok, payment_notification} =
      PaymentNotification.register_payment_notification(%{
        amount: amount,
        paid_from_email: paid_from_email,
        paid_to_email: paid_to_email,
        paid_by: paid_by,
        payment_note: payment_note,
        payment_locator: payment_locator
      })

    with {:ok, payment_service} <- PaymentService.from_email(paid_from_email),
         {:ok, payment_method} <- find_payment_method(payment_service, paid_to_email),
         {:ok, fundraiser} <- find_fundraiser(payment_method),
         {:ok, participant} <- find_participant(fundraiser, paid_by),
         {:ok, gift_card} <- guess_gift_card(participant, payment_note),
         {:ok, card_refill} <- find_card_refill(gift_card),
         {:ok, payment} <-
           Payment.register_payment(
             %{
               amount: amount,
               card_refill_id: card_refill.id,
               payment_method_id: payment_method.id
             },
             payment_notification_id: payment_notification.id
           ) do
      Logger.info("Payment made #{inspect(payment)}")
      :ok

      # find the payment service from paid_from_email
      # find the payment_method from payment service and paid_to_email (assumption: a payment service's account and its associated email serves a single fundraiser)
      # find the fundraiser from the payment method
      # find the participant from the paid_by and fundraiser
      # IF ANY OF THE ABOVE FAILS, raise a mishap - an admin will need to attend to the payment received

      # Guess the target gift card from the payment_note
      # If guessed, find the card_refill (or create it if none found), update it to show payment received, and
      # add payment referencing the payment received
      # IF NO CARD IS GUESSED, raise a mishap - an admin will need to attend to the payment received
    else
      {:error, reason} ->
        MishapService.report_mishap(%Mishap{
          doing: "#{__MODULE__}:payment_notified",
          with: [
            amount: amount,
            paid_from_email: paid_from_email,
            paid_to_email: paid_to_email,
            paid_by: paid_by,
            payment_note: payment_note,
            payment_locator: payment_locator
          ],
          causing: reason
        })
    end
  end

  defp find_payment_method(_payment_service, _paid_to_email) do
    # TODO
    {:error, :payment_method_not_found}
  end

  defp find_fundraiser(_payment_method) do
    # TODO
    {:error, :fundraiser_not_found}
  end

  defp find_participant(_fundraiser, _paid_by) do
    # TODO
    {:error, :participant_not_found}
  end

  defp guess_gift_card(_participant, _payment_note) do
    # TODO
    {:error, :gift_card_not_found}
  end

  defp find_card_refill(_gift_card) do
    # TODO
    {:error, :card_refill_not_found}
  end
end
