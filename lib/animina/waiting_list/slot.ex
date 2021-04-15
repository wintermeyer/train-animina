defmodule Animina.WaitingList.Slot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slots" do
    field :finished_at, :naive_datetime
    field :started_at, :naive_datetime
    belongs_to :team, Animina.Games.Team
    belongs_to :package, Animina.Offers.Package

    timestamps()
  end

  @doc false
  def changeset(slot, attrs) do
    slot
    |> cast(attrs, [:team_id, :package_id, :started_at, :finished_at])
    |> validate_required([:team_id, :package_id])
  end
end
