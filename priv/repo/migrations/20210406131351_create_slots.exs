defmodule Animina.Repo.Migrations.CreateSlots do
  use Ecto.Migration

  def change do
    create table(:slots) do
      add :started_at, :naive_datetime
      add :finished_at, :naive_datetime
      add :team_id, references(:teams, on_delete: :nothing)
      add :package_id, references(:packages, on_delete: :nothing)

      timestamps()
    end

    create index(:slots, [:team_id])
    create index(:slots, [:package_id])
  end
end
