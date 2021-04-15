defmodule Animina.RailControlTest do
  use Animina.DataCase

  alias Animina.RailControl

  describe "locos" do
    alias Animina.RailControl.Loco

    test "list_locos/0 returns all locos" do
      Repo.delete_all(Loco)
      loco = insert(:loco)
      assert RailControl.list_locos() == [loco]
    end

    test "get_loco!/1 returns the loco with given id" do
      loco = insert(:loco)
      assert RailControl.get_loco!(loco.id) == loco
    end

    test "create_loco/1 with valid data creates a loco" do
      assert {:ok, %Loco{} = loco} = RailControl.create_loco(%{loco_id: 42, name: "some name"})
      assert loco.loco_id == 42
      assert loco.name == "some name"
    end

    test "create_loco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RailControl.create_loco(%{loco_id: nil, name: nil})
    end

    test "update_loco/2 with valid data updates the loco" do
      loco = insert(:loco)

      assert {:ok, %Loco{} = loco} =
               RailControl.update_loco(loco, %{loco_id: 142, name: "example"})

      assert loco.loco_id == 142
      assert loco.name == "example"
    end

    test "update_loco/2 with invalid data returns error changeset" do
      loco = insert(:loco)

      assert {:error, %Ecto.Changeset{}} =
               RailControl.update_loco(loco, %{loco_id: nil, name: nil})

      assert loco == RailControl.get_loco!(loco.id)
    end

    test "delete_loco/1 deletes the loco" do
      loco = insert(:loco)
      assert {:ok, %Loco{}} = RailControl.delete_loco(loco)
      assert_raise Ecto.NoResultsError, fn -> RailControl.get_loco!(loco.id) end
    end

    test "change_loco/1 returns a loco changeset" do
      loco = insert(:loco)
      assert %Ecto.Changeset{} = RailControl.change_loco(loco)
    end
  end

  describe "loco_data_points" do
    alias Animina.RailControl.LocoDataPoint

    test "list_loco_data_points/0 returns all loco_data_points" do
      Repo.delete_all(LocoDataPoint)
      loco_data_point = insert(:loco_data_point)
      loco_data_point = RailControl.get_loco_data_point!(loco_data_point.id)
      assert RailControl.list_loco_data_points() == [loco_data_point]
    end

    test "get_loco_data_point!/1 returns the loco_data_point with given id" do
      loco_data_point = insert(:loco_data_point)
      loco_data_point = RailControl.get_loco_data_point!(loco_data_point.id)
      assert RailControl.get_loco_data_point!(loco_data_point.id) == loco_data_point
    end

    test "create_loco_data_point/1 with valid data creates a loco_data_point" do
      assert {:ok, %LocoDataPoint{} = loco_data_point} =
               RailControl.create_loco_data_point(params_with_assocs(:loco_data_point))

      assert loco_data_point.direction == 1
      assert loco_data_point.speed == 500
      assert loco_data_point.track == 1
    end

    test "create_loco_data_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RailControl.create_loco_data_point(%{speed: -100})
    end

    test "update_loco_data_point/2 with valid data updates the loco_data_point" do
      loco_data_point = insert(:loco_data_point)

      assert {:ok, %LocoDataPoint{} = loco_data_point} =
               RailControl.update_loco_data_point(loco_data_point, %{speed: 444})

      assert loco_data_point.speed == 444
    end

    test "update_loco_data_point/2 with invalid data returns error changeset" do
      loco_data_point = insert(:loco_data_point)

      assert {:error, %Ecto.Changeset{}} =
               RailControl.update_loco_data_point(loco_data_point, %{speed: -100})
    end

    test "delete_loco_data_point/1 deletes the loco_data_point" do
      loco_data_point = insert(:loco_data_point)
      assert {:ok, %LocoDataPoint{}} = RailControl.delete_loco_data_point(loco_data_point)

      assert_raise Ecto.NoResultsError, fn ->
        RailControl.get_loco_data_point!(loco_data_point.id)
      end
    end

    test "change_loco_data_point/1 returns a loco_data_point changeset" do
      loco_data_point = insert(:loco_data_point)
      assert %Ecto.Changeset{} = RailControl.change_loco_data_point(loco_data_point)
    end
  end

  describe "track_routes" do
    alias Animina.RailControl.TrackRoute

    test "list_track_routes/0 returns all track_routes" do
      Repo.delete_all(TrackRoute)
      track_route = insert(:track_route)
      assert RailControl.list_track_routes() == [track_route]
    end

    test "get_track_route!/1 returns the track_route with given id" do
      track_route = insert(:track_route)
      assert RailControl.get_track_route!(track_route.id) == track_route
    end

    test "create_track_route/1 with valid data creates a track_route" do
      assert {:ok, %TrackRoute{} = track_route} =
               RailControl.create_track_route(%{
                 destination_direction: 1,
                 destination_track: 1,
                 name: "some name",
                 route_id: 42,
                 start_direction: 1,
                 start_track: 42
               })

      assert track_route.destination_direction == 1
      assert track_route.destination_track == 1
      assert track_route.name == "some name"
      assert track_route.route_id == 42
      assert track_route.start_direction == 1
      assert track_route.start_track == 42
    end

    test "create_track_route/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RailControl.create_track_route(%{name: ""})
    end

    test "update_track_route/2 with valid data updates the track_route" do
      track_route = insert(:track_route)

      assert {:ok, %TrackRoute{} = _track_route} =
               RailControl.update_track_route(track_route, %{name: "some updated name"})
    end

    test "update_track_route/2 with invalid data returns error changeset" do
      track_route = insert(:track_route)

      assert {:error, %Ecto.Changeset{}} =
               RailControl.update_track_route(track_route, %{name: ""})

      assert track_route == RailControl.get_track_route!(track_route.id)
    end

    test "delete_track_route/1 deletes the track_route" do
      track_route = insert(:track_route)
      assert {:ok, %TrackRoute{}} = RailControl.delete_track_route(track_route)
      assert_raise Ecto.NoResultsError, fn -> RailControl.get_track_route!(track_route.id) end
    end

    test "change_track_route/1 returns a track_route changeset" do
      track_route = insert(:track_route)
      assert %Ecto.Changeset{} = RailControl.change_track_route(track_route)
    end
  end
end
