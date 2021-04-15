defmodule Animina.Trains do
  @moduledoc """
  The Trains context.
  """

  import Ecto.Query, warn: false
  alias Animina.Repo

  alias Animina.Trains.TrackPlan

  @doc """
  Returns the list of track_plans.

  ## Examples

      iex> list_track_plans()
      [%TrackPlan{}, ...]

  """
  def list_track_plans do
    Repo.all(TrackPlan)
  end

  @doc """
  Gets a single track_plan.

  Raises `Ecto.NoResultsError` if the Track plan does not exist.

  ## Examples

      iex> get_track_plan!(123)
      %TrackPlan{}

      iex> get_track_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track_plan!(id), do: Repo.get!(TrackPlan, id)

  @doc """
  Creates a track_plan.

  ## Examples

      iex> create_track_plan(%{field: value})
      {:ok, %TrackPlan{}}

      iex> create_track_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track_plan(attrs \\ %{}) do
    %TrackPlan{}
    |> TrackPlan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track_plan.

  ## Examples

      iex> update_track_plan(track_plan, %{field: new_value})
      {:ok, %TrackPlan{}}

      iex> update_track_plan(track_plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track_plan(%TrackPlan{} = track_plan, attrs) do
    track_plan
    |> TrackPlan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track_plan.

  ## Examples

      iex> delete_track_plan(track_plan)
      {:ok, %TrackPlan{}}

      iex> delete_track_plan(track_plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track_plan(%TrackPlan{} = track_plan) do
    Repo.delete(track_plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track_plan changes.

  ## Examples

      iex> change_track_plan(track_plan)
      %Ecto.Changeset{data: %TrackPlan{}}

  """
  def change_track_plan(%TrackPlan{} = track_plan, attrs \\ %{}) do
    TrackPlan.changeset(track_plan, attrs)
  end
end
