defmodule AniminaWeb.UserConfirmationController do
  use AniminaWeb, :controller

  alias Animina.Accounts
  alias AniminaWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &Routes.user_confirmation_url(conn, :confirm, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    conn
    |> put_flash(
      :info,
      gettext(
        "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."
      )
    )
    |> redirect(to: "/")
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def confirm(conn, %{"token" => token}) do
    points_bonus = Application.fetch_env!(:animina, :new_account_points_bonus)

    case Accounts.confirm_user(token) do
      {:ok, user} ->
        {:ok, transfer} =
          if user.redeemed_coupon_code do
            case CouponCode.validate(user.redeemed_coupon_code) do
              {:ok, redeemed_coupon_code} ->
                case Animina.Points.get_not_yet_redeemed_coupon(redeemed_coupon_code) do
                  nil ->
                    coupon_code_issuer = Accounts.get_user_by_coupon_code(redeemed_coupon_code)

                    Animina.Points.create_transfer(%{
                      receiver_id: coupon_code_issuer.id,
                      amount: 100,
                      description:
                        "Your coupon code #{redeemed_coupon_code} was redeemed by @#{
                          user.username
                        })"
                    })

                    {:ok, Animina.Accounts.get_user!(coupon_code_issuer.id)}
                    |> Animina.Accounts.broadcast(:user_updated)

                    Animina.Points.create_transfer(%{
                      receiver_id: user.id,
                      amount: 100 + points_bonus,
                      description:
                        "Coupon code #{redeemed_coupon_code} (issued by @#{
                          coupon_code_issuer.username
                        })"
                    })

                  coupon ->
                    Animina.Points.update_coupon(coupon, %{redeemer_id: user.id})

                    Animina.Points.create_transfer(%{
                      receiver_id: user.id,
                      amount: coupon.amount,
                      description: "Coupon code #{redeemed_coupon_code}"
                    })
                end

              _ ->
                Animina.Points.create_transfer(%{
                  receiver_id: user.id,
                  amount: points_bonus,
                  description: "Welcome present"
                })
            end
          else
            Animina.Points.create_transfer(%{
              receiver_id: user.id,
              amount: points_bonus,
              description: "Welcome present"
            })
          end

        conn
        |> put_flash(
          :info,
          gettext("User created successfully. We credited your account with %{points} points.",
            points: transfer.amount
          ) <> " 🎉"
        )
        |> UserAuth.log_in_user(user)

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(
              :error,
              gettext("Account confirmation link is invalid or it has expired.")
            )
            |> redirect(to: "/")
        end
    end
  end
end
