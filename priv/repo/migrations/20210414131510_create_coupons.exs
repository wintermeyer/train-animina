defmodule Animina.Repo.Migrations.CreateCoupons do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add :code, :string
      add :amount, :integer
      add :redeemer_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:coupons, [:code])
    create index(:coupons, [:redeemer_id])
  end
end
