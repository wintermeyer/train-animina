defmodule Animina.Repo.Migrations.CreateTrackRoutes do
  use Ecto.Migration

  def change do
    create table(:track_routes) do
      add :route_id, :integer
      add :start_track, :integer
      add :start_direction, :integer
      add :destination_track, :integer
      add :destination_direction, :integer
      add :name, :string

      timestamps()
    end

    create unique_index(:track_routes, [:name])

    create unique_index(:track_routes, [
             :route_id,
             :start_track,
             :start_direction,
             :destination_track,
             :destination_direction
           ])
  end
end
