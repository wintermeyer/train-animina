defmodule Animina.TrainsTest do
  use Animina.DataCase

  alias Animina.Trains

  describe "track_plans" do
    alias Animina.Trains.TrackPlan

    @valid_attrs %{description: "some description", name: "some name", slug: "some slug"}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      slug: "some updated slug"
    }
    @invalid_attrs %{description: nil, name: nil, slug: nil}

    def track_plan_fixture(attrs \\ %{}) do
      {:ok, track_plan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Trains.create_track_plan()

      track_plan
    end

    test "list_track_plans/0 returns all track_plans" do
      Repo.delete_all(TrackPlan)
      assert Trains.list_track_plans() == []
      assert {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))
      assert Trains.list_track_plans() == [track_plan]
    end

    test "get_track_plan!/1 returns the track_plan with given id" do
      {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))
      assert Trains.get_track_plan!(track_plan.id) == track_plan
    end

    test "create_track_plan/1 with valid data creates a track_plan" do
      assert {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))
      assert track_plan.name =~ "Track"
      assert track_plan.description == nil
      assert track_plan.slug =~ "track"
    end

    test "create_track_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trains.create_track_plan(@invalid_attrs)
    end

    test "update_track_plan/2 with valid data updates the track_plan" do
      {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))

      assert {:ok, %TrackPlan{} = track_plan} =
               Trains.update_track_plan(track_plan, @update_attrs)

      assert track_plan.description == "some updated description"
      assert track_plan.name == "some updated name"
      assert track_plan.slug =~ "track"
    end

    test "update_track_plan/2 with invalid data returns error changeset" do
      {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))
      assert {:error, %Ecto.Changeset{}} = Trains.update_track_plan(track_plan, @invalid_attrs)
      assert track_plan == Trains.get_track_plan!(track_plan.id)
    end

    test "delete_track_plan/1 deletes the track_plan" do
      {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))
      assert {:ok, %TrackPlan{}} = Trains.delete_track_plan(track_plan)
      assert_raise Ecto.NoResultsError, fn -> Trains.get_track_plan!(track_plan.id) end
    end

    test "change_track_plan/1 returns a track_plan changeset" do
      {:ok, track_plan} = Trains.create_track_plan(params_for(:track_plan))
      assert %Ecto.Changeset{} = Trains.change_track_plan(track_plan)
    end
  end
end
