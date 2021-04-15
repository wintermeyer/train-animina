defmodule Animina.Repo.Migrations.CreateLocoDataPoints do
  use Ecto.Migration

  def change do
    create table(:loco_data_points) do
      add :speed, :integer
      add :direction, :integer
      add :track, :integer
      add :loco_id, references(:locos, on_delete: :nothing)

      timestamps()
    end

    create index(:loco_data_points, [:loco_id])
  end
end
