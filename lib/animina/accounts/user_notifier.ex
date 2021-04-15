defmodule Animina.Accounts.UserNotifier do
  import Swoosh.Email

  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(user, subject, body) do
    new()
    |> to({"#{user.first_name} #{user.last_name}", user.email})
    |> from({"Stefan Wintermeyer", "sw@wintermeyer-consulting.de"})
    |> subject(subject)
    |> text_body(body)
    |> Animina.Mailer.deliver()

    {:ok, %{to: user.email, body: body}}
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user, "animina.de: E-Mail Verifikation - Email address verification", """
    Hi #{user.first_name},

    bitte bestätige mit einem Klick Deinen neuen animina Account:

    #{url}

    ENGLISH:
    You can confirm your animina account by visiting the URL below:

    #{url}

    Viel Spaß!
      Stefan Wintermeyer

    --
    Wintermeyer Consulting - Johannes-Müller-Str. 10 - 56068 Koblenz - Germany
    https://www.wintermeyer-consulting.de 

    Twitter/GitHub/Misc.: @wintermeyer
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user, "animina.de: Passwort Reset - Password Reset", """
    Hi #{user.first_name},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    Viele Grüße
      Stefan Wintermeyer

    --
    Wintermeyer Consulting - Johannes-Müller-Str. 10 - 56068 Koblenz - Germany
    https://www.wintermeyer-consulting.de 

    Twitter/GitHub/Misc.: @wintermeyer
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user, "animina.de: E-Mail Adresse ändern - Change your email address", """
    Hi #{user.first_name},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    Viele Grüße
      Stefan Wintermeyer

    --
    Wintermeyer Consulting - Johannes-Müller-Str. 10 - 56068 Koblenz - Germany
    https://www.wintermeyer-consulting.de 

    Twitter/GitHub/Misc.: @wintermeyer
    """)
  end
end
