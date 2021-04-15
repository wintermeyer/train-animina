# FIXME: Test CouponControllerTest
# defmodule AniminaWeb.CouponControllerTest do
#   use AniminaWeb.ConnCase

#   alias Animina.Points

#   @create_attrs %{amount: 42, code: "some code"}
#   @update_attrs %{amount: 43, code: "some updated code"}
#   @invalid_attrs %{amount: nil, code: nil}

#   def fixture(:coupon) do
#     {:ok, coupon} = Points.create_coupon(@create_attrs)
#     coupon
#   end

#   describe "index" do
#     test "lists all coupons", %{conn: conn} do
#       conn = get(conn, Routes.coupon_path(conn, :index))
#       assert html_response(conn, 200) =~ "Listing Coupons"
#     end
#   end

#   describe "new coupon" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, Routes.coupon_path(conn, :new))
#       assert html_response(conn, 200) =~ "New Coupon"
#     end
#   end

#   describe "create coupon" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.coupon_path(conn, :create), coupon: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == Routes.coupon_path(conn, :show, id)

#       conn = get(conn, Routes.coupon_path(conn, :show, id))
#       assert html_response(conn, 200) =~ "Show Coupon"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.coupon_path(conn, :create), coupon: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Coupon"
#     end
#   end

#   describe "edit coupon" do
#     setup [:create_coupon]

#     test "renders form for editing chosen coupon", %{conn: conn, coupon: coupon} do
#       conn = get(conn, Routes.coupon_path(conn, :edit, coupon))
#       assert html_response(conn, 200) =~ "Edit Coupon"
#     end
#   end

#   describe "update coupon" do
#     setup [:create_coupon]

#     test "redirects when data is valid", %{conn: conn, coupon: coupon} do
#       conn = put(conn, Routes.coupon_path(conn, :update, coupon), coupon: @update_attrs)
#       assert redirected_to(conn) == Routes.coupon_path(conn, :show, coupon)

#       conn = get(conn, Routes.coupon_path(conn, :show, coupon))
#       assert html_response(conn, 200) =~ "some updated code"
#     end

#     test "renders errors when data is invalid", %{conn: conn, coupon: coupon} do
#       conn = put(conn, Routes.coupon_path(conn, :update, coupon), coupon: @invalid_attrs)
#       assert html_response(conn, 200) =~ "Edit Coupon"
#     end
#   end

#   describe "delete coupon" do
#     setup [:create_coupon]

#     test "deletes chosen coupon", %{conn: conn, coupon: coupon} do
#       conn = delete(conn, Routes.coupon_path(conn, :delete, coupon))
#       assert redirected_to(conn) == Routes.coupon_path(conn, :index)

#       assert_error_sent 404, fn ->
#         get(conn, Routes.coupon_path(conn, :show, coupon))
#       end
#     end
#   end

#   defp create_coupon(_) do
#     coupon = fixture(:coupon)
#     %{coupon: coupon}
#   end
# end
