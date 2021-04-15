defmodule AniminaWeb.UserRegistrationController do
  use AniminaWeb, :controller

  alias Animina.Accounts
  alias Animina.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    conn
    |> assign(:locale, get_session(conn, :locale))
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(
          :info,
          gettext(
            "Please check your email. You'll receive an email from us with a confirmation link."
          )
        )
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:locale, get_session(conn, :locale))
        |> render("new.html", changeset: changeset)
    end
  end
end
