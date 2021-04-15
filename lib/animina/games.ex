defmodule Animina.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Animina.Repo

  alias Animina.Games.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  def get_default_team!(%Animina.Accounts.User{} = user) do
    from(t in Team, where: t.owner_id == ^user.id, where: t.name == "Default", limit: 1)
    |> Repo.one()
  end

  def get_teams_ids(%Animina.Accounts.User{} = user) do
    from(t in Team, where: t.owner_id == ^user.id, select: t.id) |> Repo.all()
  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias Animina.Games.TeamMembership

  @doc """
  Returns the list of team_memberships.

  ## Examples

      iex> list_team_memberships()
      [%TeamMembership{}, ...]

  """
  def list_team_memberships do
    Repo.all(TeamMembership)
  end

  @doc """
  Gets a single team_membership.

  Raises `Ecto.NoResultsError` if the Team membership does not exist.

  ## Examples

      iex> get_team_membership!(123)
      %TeamMembership{}

      iex> get_team_membership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_membership!(id), do: Repo.get!(TeamMembership, id)

  @doc """
  Creates a team_membership.

  ## Examples

      iex> create_team_membership(%{field: value})
      {:ok, %TeamMembership{}}

      iex> create_team_membership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_membership(attrs \\ %{}) do
    %TeamMembership{}
    |> TeamMembership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_membership.

  ## Examples

      iex> update_team_membership(team_membership, %{field: new_value})
      {:ok, %TeamMembership{}}

      iex> update_team_membership(team_membership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_membership(%TeamMembership{} = team_membership, attrs) do
    team_membership
    |> TeamMembership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_membership.

  ## Examples

      iex> delete_team_membership(team_membership)
      {:ok, %TeamMembership{}}

      iex> delete_team_membership(team_membership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_membership(%TeamMembership{} = team_membership) do
    Repo.delete(team_membership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_membership changes.

  ## Examples

      iex> change_team_membership(team_membership)
      %Ecto.Changeset{data: %TeamMembership{}}

  """
  def change_team_membership(%TeamMembership{} = team_membership, attrs \\ %{}) do
    TeamMembership.changeset(team_membership, attrs)
  end
end
