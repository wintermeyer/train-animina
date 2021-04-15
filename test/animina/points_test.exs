defmodule Animina.PointsTest do
  use Animina.DataCase

  alias Animina.Points
  import Animina.Factory

  describe "transfers" do
    alias Animina.Points.Transfer

    @valid_attrs %{amount: 42, description: "some description"}
    @update_attrs %{amount: 43, description: "some updated description"}
    @invalid_attrs %{amount: nil, description: nil}

    def transfer_fixture(attrs \\ %{}) do
      {:ok, transfer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Points.create_transfer()

      transfer
    end

    test "list_transfers/0 returns all transfers" do
      transfer_with_user = insert(:transfer)
      transfer = Points.get_transfer!(transfer_with_user.id)
      assert Points.list_transfers() == [transfer]
    end

    test "get_transfer!/1 returns the transfer with given id" do
      transfer_with_receiver = insert(:transfer)
      transfer = Points.get_transfer!(transfer_with_receiver.id)
      assert Points.get_transfer!(transfer.id) == transfer
    end

    test "create_transfer/1 with valid data creates a transfer" do
      assert {:ok, %Transfer{} = transfer} =
               Points.create_transfer(params_with_assocs(:transfer, %{}))

      assert transfer.amount == 100
      assert transfer.description == nil
    end

    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Points.create_transfer(@invalid_attrs)
    end

    test "update_transfer/2 with valid data updates the transfer" do
      transfer = insert(:transfer)
      assert {:ok, %Transfer{} = transfer} = Points.update_transfer(transfer, @update_attrs)
      assert transfer.amount == 43
      assert transfer.description == "some updated description"
    end

    test "update_transfer/2 with invalid data returns error changeset" do
      transfer_with_receiver = insert(:transfer)
      transfer = Points.get_transfer!(transfer_with_receiver.id)
      assert {:error, %Ecto.Changeset{}} = Points.update_transfer(transfer, @invalid_attrs)
      assert transfer == Points.get_transfer!(transfer.id)
    end

    test "delete_transfer/1 deletes the transfer" do
      transfer = insert(:transfer)
      assert {:ok, %Transfer{}} = Points.delete_transfer(transfer)
      assert_raise Ecto.NoResultsError, fn -> Points.get_transfer!(transfer.id) end
    end

    test "change_transfer/1 returns a transfer changeset" do
      transfer = insert(:transfer)
      assert %Ecto.Changeset{} = Points.change_transfer(transfer)
    end
  end

  # FIXME: Test for Coupons
  # describe "coupons" do
  #   alias Animina.Points.Coupon

  #   @valid_attrs %{amount: 42, code: CouponCode.generate()}
  #   @update_attrs %{amount: 43, code: CouponCode.generate()}
  #   @invalid_attrs %{amount: nil, code: nil}

  #   def coupon_fixture(attrs \\ %{}) do
  #     {:ok, coupon} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Points.create_coupon()

  #     coupon
  #   end

  #   test "list_coupons/0 returns all coupons" do
  #     coupon = coupon_fixture()
  #     assert Points.list_coupons() == [coupon]
  #   end

  #   test "get_coupon!/1 returns the coupon with given id" do
  #     coupon = coupon_fixture()
  #     assert Points.get_coupon!(coupon.id) == coupon
  #   end

  #   test "create_coupon/1 with valid data creates a coupon" do
  #     assert {:ok, %Coupon{} = coupon} = Points.create_coupon(@valid_attrs)
  #     assert coupon.amount == 42
  #     assert coupon.code == "some code"
  #   end

  #   test "create_coupon/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Points.create_coupon(@invalid_attrs)
  #   end

  #   test "update_coupon/2 with valid data updates the coupon" do
  #     coupon = coupon_fixture()
  #     assert {:ok, %Coupon{} = coupon} = Points.update_coupon(coupon, @update_attrs)
  #     assert coupon.amount == 43
  #     assert coupon.code == "some updated code"
  #   end

  #   test "update_coupon/2 with invalid data returns error changeset" do
  #     coupon = coupon_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Points.update_coupon(coupon, @invalid_attrs)
  #     assert coupon == Points.get_coupon!(coupon.id)
  #   end

  #   test "delete_coupon/1 deletes the coupon" do
  #     coupon = coupon_fixture()
  #     assert {:ok, %Coupon{}} = Points.delete_coupon(coupon)
  #     assert_raise Ecto.NoResultsError, fn -> Points.get_coupon!(coupon.id) end
  #   end

  #   test "change_coupon/1 returns a coupon changeset" do
  #     coupon = coupon_fixture()
  #     assert %Ecto.Changeset{} = Points.change_coupon(coupon)
  #   end
  # end
end
