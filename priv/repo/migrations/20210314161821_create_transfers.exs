defmodule Animina.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :amount, :integer, null: false
      add :description, :string
      add :receiver_id, references(:users, on_delete: :nothing), null: false
      add :sender_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:transfers, [:receiver_id])
    create index(:transfers, [:sender_id])
  end
end
