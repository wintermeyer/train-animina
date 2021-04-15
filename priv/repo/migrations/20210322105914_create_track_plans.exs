defmodule Animina.Repo.Migrations.CreateTrackPlans do
  use Ecto.Migration

  def change do
    create table(:track_plans) do
      add :name, :string, null: false
      add :description, :string
      add :slug, :string, null: false

      timestamps()
    end

    create unique_index(:track_plans, [:slug])
    create unique_index(:track_plans, [:name])
  end
end
