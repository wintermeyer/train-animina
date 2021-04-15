defmodule Animina.RailControl do
  @moduledoc """
  The RailControl context.
  """

  import Ecto.Query, warn: false
  alias Animina.Repo

  alias Animina.RailControl.Loco
  alias Animina.RailControl.LocoDataPoint

  @doc """
  Returns the list of locos.

  ## Examples

      iex> list_locos()
      [%Loco{}, ...]

  """
  def list_locos do
    Repo.all(Loco)
  end

  @doc """
  Gets a single loco.

  Raises `Ecto.NoResultsError` if the Loco does not exist.

  ## Examples

      iex> get_loco!(123)
      %Loco{}

      iex> get_loco!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loco!(id), do: Repo.get!(Loco, id)

  def get_loco_by_name(name) do
    query =
      from l in Loco,
        where: l.name == ^name,
        limit: 1

    Repo.one(query)
  end

  def find_or_create_loco(%{name: name, loco_id: loco_id}) do
    query =
      from l in Loco,
        where: l.name == ^name,
        where: l.loco_id == ^loco_id,
        limit: 1

    case Repo.one(query) do
      %Loco{} = loco ->
        loco

      _ ->
        {:ok, loco} = create_loco(%{name: name, loco_id: loco_id})
        loco
    end
  end

  def get_last_data_point_for_loco(%Animina.RailControl.Loco{} = loco) do
    query =
      from l in LocoDataPoint,
        where: l.loco_id == ^loco.loco_id,
        order_by: [desc: l.inserted_at],
        limit: 1

    Repo.one(query)
  end

  @doc """
  Creates a loco.

  ## Examples

      iex> create_loco(%{field: value})
      {:ok, %Loco{}}

      iex> create_loco(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loco(attrs \\ %{}) do
    %Loco{}
    |> Loco.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loco.

  ## Examples

      iex> update_loco(loco, %{field: new_value})
      {:ok, %Loco{}}

      iex> update_loco(loco, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loco(%Loco{} = loco, attrs) do
    loco
    |> Loco.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loco.

  ## Examples

      iex> delete_loco(loco)
      {:ok, %Loco{}}

      iex> delete_loco(loco)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loco(%Loco{} = loco) do
    Repo.delete(loco)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loco changes.

  ## Examples

      iex> change_loco(loco)
      %Ecto.Changeset{data: %Loco{}}

  """
  def change_loco(%Loco{} = loco, attrs \\ %{}) do
    Loco.changeset(loco, attrs)
  end

  alias Animina.RailControl.LocoDataPoint

  @doc """
  Returns the list of loco_data_points.

  ## Examples

      iex> list_loco_data_points()
      [%LocoDataPoint{}, ...]

  """
  def list_loco_data_points do
    Repo.all(LocoDataPoint)
  end

  @doc """
  Gets a single loco_data_point.

  Raises `Ecto.NoResultsError` if the Loco data point does not exist.

  ## Examples

      iex> get_loco_data_point!(123)
      %LocoDataPoint{}

      iex> get_loco_data_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loco_data_point!(id), do: Repo.get!(LocoDataPoint, id)

  @doc """
  Creates a loco_data_point.

  ## Examples

      iex> create_loco_data_point(%{field: value})
      {:ok, %LocoDataPoint{}}

      iex> create_loco_data_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loco_data_point(attrs \\ %{}) do
    changeset =
      %LocoDataPoint{}
      |> LocoDataPoint.changeset(attrs)

    if changeset.valid? do
      loco = Animina.RailControl.get_loco!(changeset.changes.loco_id)

      {:ok, _} = update_loco(loco, attrs)
    end

    changeset
    |> Repo.insert()
  end

  @doc """
  Updates a loco_data_point.

  ## Examples

      iex> update_loco_data_point(loco_data_point, %{field: new_value})
      {:ok, %LocoDataPoint{}}

      iex> update_loco_data_point(loco_data_point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loco_data_point(%LocoDataPoint{} = loco_data_point, attrs) do
    loco_data_point
    |> LocoDataPoint.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loco_data_point.

  ## Examples

      iex> delete_loco_data_point(loco_data_point)
      {:ok, %LocoDataPoint{}}

      iex> delete_loco_data_point(loco_data_point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loco_data_point(%LocoDataPoint{} = loco_data_point) do
    Repo.delete(loco_data_point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loco_data_point changes.

  ## Examples

      iex> change_loco_data_point(loco_data_point)
      %Ecto.Changeset{data: %LocoDataPoint{}}

  """
  def change_loco_data_point(%LocoDataPoint{} = loco_data_point, attrs \\ %{}) do
    LocoDataPoint.changeset(loco_data_point, attrs)
  end

  alias Animina.RailControl.TrackRoute

  @doc """
  Returns the list of track_routes.

  ## Examples

      iex> list_track_routes()
      [%TrackRoute{}, ...]

  """
  def list_track_routes do
    Repo.all(TrackRoute)
  end

  @doc """
  Gets a single track_route.

  Raises `Ecto.NoResultsError` if the Track route does not exist.

  ## Examples

      iex> get_track_route!(123)
      %TrackRoute{}

      iex> get_track_route!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track_route!(id), do: Repo.get!(TrackRoute, id)

  @doc """
  Creates a track_route.

  ## Examples

      iex> create_track_route(%{field: value})
      {:ok, %TrackRoute{}}

      iex> create_track_route(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track_route(attrs \\ %{}) do
    %TrackRoute{}
    |> TrackRoute.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track_route.

  ## Examples

      iex> update_track_route(track_route, %{field: new_value})
      {:ok, %TrackRoute{}}

      iex> update_track_route(track_route, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track_route(%TrackRoute{} = track_route, attrs) do
    track_route
    |> TrackRoute.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track_route.

  ## Examples

      iex> delete_track_route(track_route)
      {:ok, %TrackRoute{}}

      iex> delete_track_route(track_route)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track_route(%TrackRoute{} = track_route) do
    Repo.delete(track_route)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track_route changes.

  ## Examples

      iex> change_track_route(track_route)
      %Ecto.Changeset{data: %TrackRoute{}}

  """
  def change_track_route(%TrackRoute{} = track_route, attrs \\ %{}) do
    TrackRoute.changeset(track_route, attrs)
  end
end
