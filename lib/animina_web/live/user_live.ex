defmodule AniminaWeb.UserLive do
  use AniminaWeb, :live_view

  alias AniminaWeb.{
    HeaderComponent,
    FooterComponent,
    FlashMessageComponent
  }

  alias Animina.{
    Presence,
    Chats,
    Accounts
  }

  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(%{"username" => username} = _params, session, socket) do
    user = Accounts.get_user_by_username(username)

    Gettext.put_locale(AniminaWeb.Gettext, session["locale"])

    current_user = get_current_user(session)

    [chat_user_id, user_status] =
      case current_user do
        nil -> [UUID.uuid4(), "guest"]
        user -> [user.id, "user"]
      end

    # The "Lobby" Chat for registered users
    room = Chats.get_room_by_slug("lobby")

    if connected?(socket) do
      if current_user, do: Accounts.subscribe(current_user)
      Accounts.subscribe(user)
      Chats.subscribe(room)
    end

    # The Presense to keep track of users
    Phoenix.PubSub.subscribe(Animina.PubSub, room.slug)
    {:ok, _} = Presence.track(self(), room.slug, chat_user_id, %{status: user_status, room: room})

    socket =
      socket
      |> assign(user: user)
      |> assign(locale: session["locale"])
      |> assign(current_user: current_user)
      |> assign_current_users_info(room)
      |> assign(room: room)
      |> assign(:messages, Chats.newest_messages())
      |> assign(:messages_by_user, Chats.newest_messages_of_user(user))
      |> assign(
        :message,
        Chats.change_message(%Animina.Chats.Message{room: room, user: current_user})
      )

    {:ok, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    room = socket.assigns.room

    socket =
      socket
      |> assign_current_users_info(room)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:message_created, message}, socket) do
    socket =
      update(
        socket,
        :messages,
        fn messages -> List.delete_at(messages ++ [message], 0) end
      )

    socket =
      if message.user_id == socket.assigns.user.id do
        socket =
          update(
            socket,
            :messages_by_user,
            fn messages_by_user -> Enum.slice([message] ++ messages_by_user, 0, 250) end
          )

        socket
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:message_updated, _message}, socket) do
    # FIXME: Should only change if message is in messages.
    Chats.newest_messages()

    socket =
      update(
        socket,
        :messages,
        Chats.newest_messages()
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info({:user_updated, %Accounts.User{} = user}, socket) do
    socket =
      if socket.assigns.current_user && socket.assigns.current_user.id == user.id do
        assign(socket, current_user: user)
      else
        socket
      end

    socket =
      if socket.assigns.user && socket.assigns.user.id == user.id do
        assign(socket, user: user)
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("message", %{"message" => message_params}, socket) do
    Chats.create_message(message_params)
    {:noreply, socket}
  end

  defp current_user_ids(room) do
    Presence.list(room.slug)
    |> Enum.filter(fn {_id, x} -> hd(x.metas).status == "user" end)
    |> Enum.map(fn {k, _} -> k end)
  end

  defp assign_current_users_info(socket, room) do
    current_user_ids = current_user_ids(room)

    latest_usernames_and_email_md5sums =
      Accounts.list_latest_usernames_and_email_md5sums_by_ids(current_user_ids)

    socket
    |> assign(latest_usernames_and_email_md5sums: latest_usernames_and_email_md5sums)
    |> assign(:current_user_count, length(current_user_ids))
  end
end
