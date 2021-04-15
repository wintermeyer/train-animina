defmodule Animina.Offers.Package do
  use Ecto.Schema
  import Ecto.Changeset

  schema "packages" do
    field :active, :boolean, default: false
    field :description, :string
    field :includes_appointment, :boolean, default: false
    field :locos, :integer
    field :name, :string
    field :players, :integer
    field :points, :integer
    field :seconds, :integer
    field :stations, :integer

    timestamps()
  end

  @doc false
  def changeset(package, attrs) do
    package
    |> cast(attrs, [
      :name,
      :description,
      :locos,
      :players,
      :seconds,
      :stations,
      :points,
      :active,
      :includes_appointment
    ])
    |> validate_required([
      :name,
      :locos,
      :players,
      :seconds,
      :stations,
      :points,
      :active,
      :includes_appointment
    ])
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:description, max: 255)
    |> validate_number(:players, greater_than: 0)
    |> validate_number(:players, less_than: 10)
    |> validate_number(:stations, greater_than: 0)
    |> validate_number(:stations, less_than: 200)
    |> validate_number(:points, greater_than: 0)
    |> validate_number(:seconds, greater_than: 0)
  end
end
