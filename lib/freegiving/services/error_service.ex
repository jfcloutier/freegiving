defmodule Freegiving.Services.ErrorService do
  @moduledoc """
  Error reporting.
  """

  alias Freegiving.{Error, Mailer}
  alias Freegiving.Accounts
  alias Swoosh.Email
  require Logger

  def report_error(%Error{doing: doing, with: arguments, causing: cause} = error) do
    Logger.warn("Reporting error #{inspect(error)}")

    admin_emails = Accounts.admin_user_emails()

    arguments_text =
      for(argument <- arguments, do: argument_to_string(argument)) |> Enum.join("\n")

    now = DateTime.utc_now() |> DateTime.to_string()

    body = """
    Error
    =====

    doing: #{inspect(doing)}
    with: #{arguments_text}
    cause: #{inspect(cause)}

    #{now}
    """

    email =
      Email.new()
      |> Email.to(admin_emails)
      |> Email.from({"Dev", "dev@yourgrocerycard.gives"})
      |> Email.reply_to("no-reply@yourgrocerycard.gives")
      |> Email.subject("Error doing #{inspect(doing)}")
      |> Email.text_body(body)

    Mailer.deliver!(email)
  end

  defp argument_to_string(arg) when is_struct(arg) do
    if :id in Map.keys(arg) do
      schema_name =
        "#{Map.get(arg, :__struct__)}"
        |> String.split(".")
        |> List.last()

      "#{schema_name} #{Map.get(arg, :id)}"
    else
      "#{inspect(arg)}"
    end
  end

  defp argument_to_string(arg), do: inspect(arg)
end
