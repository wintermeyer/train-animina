defmodule AniminaWeb.LiveHelpers do
  alias Animina.Accounts

  def get_current_user(session) do
    case session["user_token"] do
      nil -> nil
      user_token -> Accounts.get_user_by_session_token(user_token)
    end
  end
end
