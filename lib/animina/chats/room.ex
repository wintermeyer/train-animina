defmodule Animina.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Animina.Slugs.NameSlug

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :slug, NameSlug.Type
    has_many :messages, Animina.Chats.Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> NameSlug.maybe_generate_slug()
    |> NameSlug.unique_constraint()
    |> validate_required([:slug])
  end
end
