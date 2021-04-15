defmodule Animina.RailControl.LocoDataPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loco_data_points" do
    field :direction, :integer
    field :speed, :integer
    field :track, :integer
    belongs_to :loco, Animina.RailControl.Loco

    timestamps()
  end

  @doc false
  def changeset(loco_data_point, attrs) do
    loco_data_point
    |> cast(attrs, [:speed, :direction, :track, :loco_id])
    |> validate_required([:speed, :direction, :track, :loco_id])
    |> validate_number(:speed, greater_than_or_equal_to: 0)
    |> validate_number(:track, greater_than_or_equal_to: 0)
    |> validate_inclusion(:direction, 0..1)
    |> assoc_constraint(:loco)
  end
end
