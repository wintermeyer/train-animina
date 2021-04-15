defmodule AniminaWeb.UserRegistrationControllerTest do
  use AniminaWeb.ConnCase, async: true

  import Animina.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => email,
            "password" => valid_user_password(),
            "gender" => valid_gender(),
            "first_name" => valid_first_name(),
            "last_name" => valid_last_name(),
            "username" => unique_username(),
            "lang" => valid_lang(),
            "timezone" => valid_timezone()
          }
        })

      # assert get_session(conn, :user_token)
      assert redirected_to(conn) =~ "/"

      # TODO: Test that an email was sent and that the user is not logged in.

      # Now do a logged in request and assert on the menu
      # conn = get(conn, "/")
      # response = html_response(conn, 200)
      # assert response =~ email
      # assert response =~ "Einstellungen"
      # assert response =~ "Abmelden"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{
            "email" => "with spaces",
            "password" => "too short",
            "gender" => valid_gender(),
            "first_name" => valid_first_name(),
            "last_name" => valid_last_name(),
            "username" => unique_username(),
            "lang" => valid_lang()
          }
        })

      response = html_response(conn, 200)
      assert response =~ "should be at least"
      assert response =~ "must have the @ sign and no spaces"
    end
  end
end
