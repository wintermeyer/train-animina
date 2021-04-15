defmodule Animina.UserHelper do
  use Timex

  def full_name(user) do
    case user do
      nil -> ""
      user -> "#{user.first_name} #{user.last_name}"
    end
  end

  def avatar_src(%Animina.Accounts.User{email_md5sum: email_md5sum}) do
    "https://www.gravatar.com/avatar/" <> email_md5sum <> "?d=mp"
  end

  def avatar_src(email_md5sum) do
    case email_md5sum do
      nil -> ""
      email_md5sum -> "https://www.gravatar.com/avatar/" <> email_md5sum
    end
  end

  def hh_mm(timestamp, user) do
    convert_to_locale_time(timestamp, user)
    |> Timex.format!("%H:%M", :strftime)
  end

  def hh_mm_dd_mm_yy(timestamp, user) do
    convert_to_locale_time(timestamp, user)
    |> Timex.format!("%H:%M (%d.%m.%y)", :strftime)
  end

  def dd_mm_yyyy_hh_mm_ss(timestamp, user) do
    convert_to_locale_time(timestamp, user)
    |> Timex.format!("%d.%m.%Y %H:%M:%S ", :strftime)
  end

  defp convert_to_locale_time(timestamp, user) do
    case user do
      %Animina.Accounts.User{timezone: timezone} ->
        Timezone.convert(timestamp, timezone)

      _ ->
        Timezone.convert(timestamp, "Europe/Berlin")
    end
  end
end
