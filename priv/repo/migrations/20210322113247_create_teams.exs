defmodule Animina.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :description, :string
      add :slug, :string, null: false
      add :owner_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:teams, [:owner_id])
    create unique_index(:teams, [:owner_id, :slug])
    create unique_index(:teams, [:owner_id, :name])
  end
end
