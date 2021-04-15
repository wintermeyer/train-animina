defmodule Animina.OffersTest do
  use Animina.DataCase

  alias Animina.Offers

  describe "packages" do
    alias Animina.Offers.Package

    # @valid_attrs %{
    #   active: true,
    #   description: "some description",
    #   includes_appointment: true,
    #   locos: 1,
    #   name: "some name",
    #   players: 1,
    #   points: 200,
    #   seconds: 60,
    #   stations: 3
    # }
    @update_attrs %{
      active: false,
      description: "some updated description",
      includes_appointment: false,
      locos: 2,
      name: "some updated name",
      players: 2,
      points: 300,
      seconds: 90,
      stations: 5
    }
    @invalid_attrs %{
      active: nil,
      description: nil,
      includes_appointment: nil,
      locos: nil,
      name: nil,
      players: nil,
      points: nil,
      seconds: nil,
      stations: nil
    }

    # def package_fixture(attrs \\ %{}) do
    #   {:ok, package} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Offers.create_package()

    #   package
    # end

    test "list_packages/0 returns all packages" do
      Repo.delete_all(Package)
      package = insert(:package)
      assert Offers.list_packages() == [package]
    end

    test "get_package!/1 returns the package with given id" do
      package = insert(:package)
      assert Offers.get_package!(package.id) == package
    end

    test "create_package/1 with valid data creates a package" do
      assert {:ok, %Package{} = package} = Offers.create_package(params_for(:package))
      assert package.active == true
      assert package.includes_appointment == false
      assert package.locos == 1
      assert package.players == 1
      assert package.points == 200
      assert package.seconds == 60
      assert package.stations == 3
    end

    test "create_package/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Offers.create_package(@invalid_attrs)
    end

    test "update_package/2 with valid data updates the package" do
      package = insert(:package)
      assert {:ok, %Package{} = package} = Offers.update_package(package, @update_attrs)
      assert package.active == false
      assert package.description == "some updated description"
      assert package.includes_appointment == false
      assert package.locos == 2
      assert package.name == "some updated name"
      assert package.players == 2
      assert package.points == 300
      assert package.seconds == 90
      assert package.stations == 5
    end

    test "update_package/2 with invalid data returns error changeset" do
      package = insert(:package)
      assert {:error, %Ecto.Changeset{}} = Offers.update_package(package, @invalid_attrs)
      assert package == Offers.get_package!(package.id)
    end

    test "delete_package/1 deletes the package" do
      package = insert(:package)
      assert {:ok, %Package{}} = Offers.delete_package(package)
      assert_raise Ecto.NoResultsError, fn -> Offers.get_package!(package.id) end
    end

    test "change_package/1 returns a package changeset" do
      package = insert(:package)
      assert %Ecto.Changeset{} = Offers.change_package(package)
    end
  end
end
