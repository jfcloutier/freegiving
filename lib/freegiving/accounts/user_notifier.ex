defmodule Freegiving.Accounts.UserNotifier do
  alias Swoosh.Email
  require Logger

  defp deliver(to, subject, body) do
    email =
      Email.new()
      |> Email.to(to)
      |> Email.from({"Dev", "dev@yourgrocerycard.gives"})
      |> Email.reply_to("no-reply@yourgrocerycard.gives")
      |> Email.subject(subject)
      # |> Email.html_body(body)
      |> Email.text_body(body)

    Logger.info("Delivering email #{inspect(email)}")
    Freegiving.Mailer.deliver!(email)
    {:ok, %{to: to, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Registration confirmation", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Resetting your password", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Changing your email email", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
