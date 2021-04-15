defmodule Animina.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Animina.Repo

  alias Animina.Chats.Room

  def subscribe(%Animina.Chats.Room{} = room) do
    Phoenix.PubSub.subscribe(Animina.PubSub, "room-id#{room.id}")
  end

  def broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(
      Animina.PubSub,
      "room-id#{message.room_id}",
      {event, message}
    )

    {:ok, message}
  end

  def broadcast({:error, _reason} = error, _event), do: error

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Gets a single room by slug.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room_by_slug("lobby")
      %Room{}

  """
  def get_room_by_slug(slug) do
    Repo.one(from r in Room, where: r.slug == ^slug, limit: 1)
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end

  alias Animina.Chats.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  def newest_messages() do
    query = from m in Message, order_by: [desc: :inserted_at], limit: 6
    Repo.all(query) |> Repo.preload(user: [:messages]) |> Enum.reverse()
  end

  def newest_messages_of_user(%Animina.Accounts.User{} = user, limit \\ 250) do
    query =
      from m in Message,
        where: m.user_id == ^user.id,
        order_by: [desc: :inserted_at],
        limit: ^limit

    Repo.all(query) |> Repo.preload(user: [:messages])
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    {status, message} =
      %Message{}
      |> Message.changeset(attrs)
      |> Repo.insert()

    case status do
      :ok ->
        message =
          message
          |> Repo.preload(:user)

        {:ok, message}
        |> broadcast(:message_created)

      status ->
        {status, message}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    {status, message} =
      message
      |> Message.changeset(attrs)
      |> Repo.update()

    case status do
      :ok ->
        message =
          message
          |> Repo.preload(:user)

        {:ok, message}
        |> broadcast(:message_created)

      status ->
        {status, message}
    end
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
