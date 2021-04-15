defmodule Animina.Chats.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    belongs_to :room, Animina.Chats.Room
    belongs_to :user, Animina.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_id, :room_id])
    |> validate_required([:content, :user_id, :room_id])
    |> validate_length(:content, min: 1, max: 255)
    |> assoc_constraint(:user)
    |> assoc_constraint(:room)
  end
end
