defmodule AniminaWeb.CouponController do
  use AniminaWeb, :controller

  alias Animina.Points
  alias Animina.Points.Coupon

  def index(conn, _params) do
    coupons = Points.list_coupons()
    render(conn, "index.html", coupons: coupons)
  end

  def new(conn, _params) do
    changeset = Points.change_coupon(%Coupon{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"coupon" => coupon_params}) do
    case Points.create_coupon(coupon_params) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon created successfully.")
        |> redirect(to: Routes.coupon_path(conn, :show, coupon))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    coupon = Points.get_coupon!(id)
    render(conn, "show.html", coupon: coupon)
  end

  def edit(conn, %{"id" => id}) do
    coupon = Points.get_coupon!(id)
    changeset = Points.change_coupon(coupon)
    render(conn, "edit.html", coupon: coupon, changeset: changeset)
  end

  def update(conn, %{"id" => id, "coupon" => coupon_params}) do
    coupon = Points.get_coupon!(id)

    case Points.update_coupon(coupon, coupon_params) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon updated successfully.")
        |> redirect(to: Routes.coupon_path(conn, :show, coupon))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", coupon: coupon, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    coupon = Points.get_coupon!(id)
    {:ok, _coupon} = Points.delete_coupon(coupon)

    conn
    |> put_flash(:info, "Coupon deleted successfully.")
    |> redirect(to: Routes.coupon_path(conn, :index))
  end
end
