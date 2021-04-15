defmodule Animina.RailControl.TrackRoute do
  use Ecto.Schema
  import Ecto.Changeset

  schema "track_routes" do
    field :destination_direction, :integer
    field :destination_track, :integer
    field :name, :string
    field :route_id, :integer
    field :start_direction, :integer
    field :start_track, :integer

    timestamps()
  end

  @doc false
  def changeset(track_route, attrs) do
    track_route
    |> cast(attrs, [
      :route_id,
      :start_track,
      :start_direction,
      :destination_track,
      :destination_direction,
      :name
    ])
    |> validate_required([
      :route_id,
      :start_track,
      :start_direction,
      :destination_track,
      :destination_direction,
      :name
    ])
    |> validate_number(:route_id, greater_than_or_equal_to: 0)
    |> validate_number(:start_track, greater_than_or_equal_to: 0)
    |> validate_number(:destination_track, greater_than_or_equal_to: 0)
    |> validate_inclusion(:destination_direction, 0..1)
    |> validate_inclusion(:start_direction, 0..1)
    |> validate_length(:name, min: 1)
    |> unique_constraint(:name)
  end
end
