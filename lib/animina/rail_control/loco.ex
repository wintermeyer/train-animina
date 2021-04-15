defmodule Animina.RailControl.Loco do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locos" do
    field :loco_id, :integer
    field :name, :string
    field :direction, :integer
    field :speed, :integer
    field :track, :integer

    timestamps()
  end

  @doc false
  def changeset(loco, attrs) do
    loco
    |> cast(attrs, [:loco_id, :name, :direction, :speed, :track])
    |> validate_required([:loco_id, :name])
    |> unique_constraint(:name)
    |> validate_number(:speed, greater_than_or_equal_to: 0)
    |> validate_number(:track, greater_than_or_equal_to: 0)
    |> validate_inclusion(:direction, 0..1)
  end
end
