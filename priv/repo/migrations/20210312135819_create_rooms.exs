defmodule Animina.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false
      add :description, :text
      add :slug, :string, null: false

      timestamps()
    end

    create unique_index(:rooms, [:slug])
  end
end
