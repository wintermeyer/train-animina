defmodule Animina.Games.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Animina.Slugs.NameSlug

  schema "teams" do
    field :description, :string
    field :name, :string
    field :slug, NameSlug.Type
    belongs_to :owner, Animina.Accounts.User, foreign_key: :owner_id
    has_many :team_memberships, Animina.Games.TeamMembership
    has_many :users, through: [:team_memberships, :user]

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :description, :owner_id])
    |> validate_required([:name, :owner_id])
    |> validate_length(:name, min: 1, max: 80)
    |> assoc_constraint(:owner)
    |> NameSlug.maybe_generate_slug()
    |> NameSlug.unique_constraint()
    |> validate_required([:slug])
    |> unique_constraint([:owner_id, :slug])
    |> unique_constraint([:owner_id, :name])
  end
end
