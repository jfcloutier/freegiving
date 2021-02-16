defmodule Freegiving.Services.PaymentNotificationService do
  @moduledoc """
  Payment notification service.
  For each payment notification, try to create a payment for a card refill.
  """

  alias Freegiving.Fundraisers.Payment

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
    # store in payments_received
    # find the payment service from paid_from_email
    # find the payment_method from payment service and paid_to_email (assumption: a payment service's account and its associated email serves a single fundraiser)
    # find the fundraiser from the payment method
    # find the participant from the paid_by and fundraiser
    # IF ANY OF THE ABOVE FAILS, raise a mishap - an admin will need to attend to the payment received

    # Guess the target gift card from the payment_note
    # If guessed, find the card_refill (or create it if none found), update it to show payment received, and
    # add payment referencing the payment received
    # IF NO CARD IS GUESSED, raise a mishap - an admin will need to attend to the payment received
  end

  # TODO - Store all received payments with above data in table payments_received. Problematic payments don't reference payments.
end
