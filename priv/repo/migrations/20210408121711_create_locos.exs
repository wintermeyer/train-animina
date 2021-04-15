defmodule Animina.Repo.Migrations.CreateLocos do
  use Ecto.Migration

  def change do
    create table(:locos) do
      add :loco_id, :integer, null: false
      add :name, :string, null: false
      add :direction, :integer
      add :speed, :integer
      add :track, :integer

      timestamps()
    end

    create unique_index(:locos, [:name])
  end
end
