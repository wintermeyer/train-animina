defmodule Animina.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :gender, :string, null: false
      add :birthday, :date
      add :username, :string, null: false
      add :email_md5sum, :string
      add :homepage, :string
      add :about, :text
      add :lang, :string, null: false
      add :timezone, :string, null: false
      add :points, :integer, default: 0
      add :lifetime_points, :integer, default: 0
      add :coupon_code, :string, null: false
      add :redeemed_coupon_code, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
    create unique_index(:users, [:coupon_code])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
