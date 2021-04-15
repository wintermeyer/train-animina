defmodule Animina.Trains.TrackPlan do
  use Ecto.Schema
  import Ecto.Changeset
  alias Animina.Slugs.NameSlug

  schema "track_plans" do
    field :description, :string
    field :name, :string
    field :slug, NameSlug.Type

    timestamps()
  end

  @doc false
  def changeset(track_plan, attrs) do
    track_plan
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> NameSlug.maybe_generate_slug()
    |> NameSlug.unique_constraint()
    |> validate_required([:slug])
  end
end
