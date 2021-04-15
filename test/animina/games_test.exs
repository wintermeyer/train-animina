defmodule Animina.GamesTest do
  use Animina.DataCase

  alias Animina.Games

  describe "teams" do
    alias Animina.Games.Team

    @valid_attrs %{description: "some description", name: "some name", slug: "some slug"}
    @update_attrs %{
      description: "some updated description",
      name: "some updated name",
      slug: "some updated slug"
    }
    @invalid_attrs %{description: nil, name: nil, slug: nil}

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_team()

      team
    end

    test "list_teams/0 returns all teams" do
      Repo.delete_all(Team)
      assert Games.list_teams() == []
      assert {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert Games.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      assert {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert Games.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert team.description == nil
      assert team.name =~ "Team"
      assert team.slug =~ "team"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert {:ok, %Team{} = team} = Games.update_team(team, @update_attrs)
      assert team.description == "some updated description"
      assert team.name == "some updated name"
      assert team.slug =~ "team"
    end

    test "update_team/2 with invalid data returns error changeset" do
      {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert {:error, %Ecto.Changeset{}} = Games.update_team(team, @invalid_attrs)
      assert team == Games.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert {:ok, %Team{}} = Games.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Games.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      {:ok, team} = Games.create_team(params_with_assocs(:team))
      assert %Ecto.Changeset{} = Games.change_team(team)
    end
  end

  describe "team_memberships" do
    alias Animina.Games.TeamMembership

    @invalid_attrs %{team_id: nil, user_id: nil}

    def team_membership_fixture(attrs \\ %{}) do
      {:ok, team_membership} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_team_membership()

      team_membership
    end

    test "list_team_memberships/0 returns all team_memberships" do
      Repo.delete_all(TeamMembership)
      assert Games.list_team_memberships() == []

      assert {:ok, team_membership} =
               Games.create_team_membership(params_with_assocs(:team_membership))

      assert Games.list_team_memberships() == [team_membership]
    end

    test "get_team_membership!/1 returns the team_membership with given id" do
      {:ok, team_membership} = Games.create_team_membership(params_with_assocs(:team_membership))
      assert Games.get_team_membership!(team_membership.id) == team_membership
    end

    test "create_team_membership/1 with valid data creates a team_membership" do
      assert {:ok, %TeamMembership{} = _team_membership} =
               Games.create_team_membership(params_with_assocs(:team_membership))
    end

    test "create_team_membership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_team_membership(@invalid_attrs)
    end

    test "update_team_membership/2 with valid data updates the team_membership" do
      {:ok, team_membership} = Games.create_team_membership(params_with_assocs(:team_membership))
      {:ok, team} = Games.create_team(params_with_assocs(:team))

      assert {:ok, %TeamMembership{} = _team_membership} =
               Games.update_team_membership(team_membership, %{team_id: team.id})
    end

    test "update_team_membership/2 with invalid data returns error changeset" do
      {:ok, team_membership} = Games.create_team_membership(params_with_assocs(:team_membership))

      assert {:error, %Ecto.Changeset{}} =
               Games.update_team_membership(team_membership, @invalid_attrs)

      assert team_membership == Games.get_team_membership!(team_membership.id)
    end

    test "delete_team_membership/1 deletes the team_membership" do
      {:ok, team_membership} = Games.create_team_membership(params_with_assocs(:team_membership))
      assert {:ok, %TeamMembership{}} = Games.delete_team_membership(team_membership)
      assert_raise Ecto.NoResultsError, fn -> Games.get_team_membership!(team_membership.id) end
    end

    test "change_team_membership/1 returns a team_membership changeset" do
      {:ok, team_membership} = Games.create_team_membership(params_with_assocs(:team_membership))
      assert %Ecto.Changeset{} = Games.change_team_membership(team_membership)
    end
  end
end
