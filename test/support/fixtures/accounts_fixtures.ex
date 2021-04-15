defmodule Animina.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Animina.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "LeastSecurePasswordEver"
  def unique_username, do: "user#{System.unique_integer()}" |> String.slice(0..14)
  def valid_first_name, do: "Bob"
  def valid_last_name, do: "Smith"
  def valid_gender, do: "prefer not to say"
  def valid_lang, do: "en"
  def valid_timezone, do: "Europe/Berlin"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password(),
        username: unique_username(),
        gender: valid_gender(),
        first_name: valid_first_name(),
        last_name: valid_last_name(),
        lang: valid_lang(),
        timezone: valid_timezone()
      })
      |> Animina.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
