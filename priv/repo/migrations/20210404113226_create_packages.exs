defmodule Animina.Repo.Migrations.CreatePackages do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :name, :string, null: false
      add :description, :string
      add :locos, :integer, null: false
      add :players, :integer, null: false
      add :seconds, :integer, null: false
      add :stations, :integer, null: false
      add :points, :integer, null: false
      add :active, :boolean, default: false, null: false
      add :includes_appointment, :boolean, default: false, null: false

      timestamps()
    end
  end
end
