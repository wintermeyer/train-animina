defmodule Animina.Games.TeamMembership do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_memberships" do
    belongs_to :user, Animina.Accounts.User
    belongs_to :team, Animina.Games.Team

    timestamps()
  end

  @doc false
  def changeset(team_membership, attrs) do
    team_membership
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:team)
  end
end
