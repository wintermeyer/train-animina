defmodule AniminaWeb.PageLive do
  use AniminaWeb, :live_view
  require Logger

  alias AniminaWeb.{
    HeaderComponent,
    FooterComponent,
    LiveVideoComponent,
    FlashMessageComponent,
    UsersListPanelComponent,
    PackagesPanelComponent,
    FutureSlotsPanelComponent,
    WaitingListPanelComponent,
    ActiveSlotPanelComponent
  }

  alias Animina.{
    Presence,
    Chats,
    Accounts,
    WaitingList,
    RailControl
  }

  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(_params, session, socket) do
    Gettext.put_locale(AniminaWeb.Gettext, session["locale"])

    current_user = get_current_user(session)

    [chat_user_id, user_status] =
      case current_user do
        nil -> [UUID.uuid4(), "guest"]
        user -> [user.id, "user"]
      end

    # The "Lobby" Chat for registered users
    room = Chats.get_room_by_slug("lobby")

    current_user_future_slots = WaitingList.list_future_slots(current_user)

    if connected?(socket) do
      if current_user, do: Accounts.subscribe(current_user)
      Chats.subscribe(room)

      if length(current_user_future_slots) > 0, do: WaitingList.subscribe()
    end

    # The Presense to keep track of users
    Phoenix.PubSub.subscribe(Animina.PubSub, room.slug)
    {:ok, _} = Presence.track(self(), room.slug, chat_user_id, %{status: user_status, room: room})

    socket =
      socket
      |> assign(locale: session["locale"])
      |> assign(current_user: current_user)
      |> assign_current_users_info(room)
      |> assign(room: room)
      |> assign(:messages, Chats.newest_messages())
      |> assign(
        :message,
        Chats.change_message(%Animina.Chats.Message{room: room, user: current_user})
      )
      |> assign(available_packages: Animina.Offers.list_available_packages())
      |> assign(current_user_future_slots: current_user_future_slots)
      |> assign(waiting_list_slots: WaitingList.list_waiting_list_slots(20))
      |> assign(waiting_list_slots_count: WaitingList.waiting_list_slots_count())
      |> assign(active_slot: WaitingList.find_or_create_active_slot())
      |> assign(remaining_lifetime: 0)
      |> assign(track_routes: RailControl.list_track_routes())
      |> assign(locos: RailControl.list_locos())

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
  def handle_info({:user_updated, %Accounts.User{} = current_user}, socket) do
    socket =
      socket
      |> assign(current_user: current_user)

    socket =
      if WaitingList.user_member_of_active_slot?(current_user) ||
           length(WaitingList.list_future_slots(current_user)) > 0 do
        socket
        |> assign(
          current_user_future_slots: WaitingList.list_future_slots(socket.assigns.current_user)
        )
        |> assign(waiting_list_slots: WaitingList.list_waiting_list_slots(20))
        |> assign(waiting_list_slots_count: WaitingList.waiting_list_slots_count())
        |> assign(active_slot: WaitingList.find_or_create_active_slot())
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:subscribe_waiting_list, %Accounts.User{} = _current_user}, socket) do
    WaitingList.subscribe()
    {:noreply, socket} = handle_info({:update_waitinglist}, socket)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:unsubscribe_waiting_list, %Accounts.User{} = _current_user}, socket) do
    WaitingList.unsubscribe()
    {:noreply, socket} = handle_info({:update_waitinglist}, socket)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:subscribe_active_slot_channel}, socket) do
    Phoenix.PubSub.subscribe(Animina.PubSub, "active-slot-channel")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:unsubscribe_active_slot_channel}, socket) do
    Phoenix.PubSub.unsubscribe(Animina.PubSub, "active-slot-channel")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_remaining_lifetime}, socket) do
    slot = WaitingList.currently_active_slot()

    remaining_lifetime =
      case slot do
        %Animina.WaitingList.Slot{} = slot ->
          WaitingList.remaining_lifetime(slot)

        _ ->
          nil
      end

    socket =
      socket
      |> assign(remaining_lifetime: remaining_lifetime)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_waitinglist}, socket) do
    current_user_future_slots = WaitingList.list_future_slots(socket.assigns.current_user)

    socket =
      socket
      |> assign(current_user_future_slots: current_user_future_slots)
      |> assign(waiting_list_slots: WaitingList.list_waiting_list_slots(20))
      |> assign(waiting_list_slots_count: WaitingList.waiting_list_slots_count())
      |> assign(active_slot: WaitingList.find_or_create_active_slot())

    if length(current_user_future_slots) == 0 do
      WaitingList.unsubscribe()
    end

    {:noreply, socket}
  end

  def handle_info({:update_locos}, socket) do
    socket =
      socket
      |> assign(locos: RailControl.list_locos())

    {:noreply, socket}
  end

  @impl true
  def handle_event("message", %{"message" => message_params}, socket) do
    Chats.create_message(message_params)
    {:noreply, socket}
  end

  def handle_event("create_slot", %{"package_id" => package_id}, socket) do
    WaitingList.create_slot(%{
      package_id: package_id,
      team_id: Animina.Games.get_default_team!(socket.assigns.current_user).id
    })

    socket =
      socket
      |> assign(
        current_user_future_slots: WaitingList.list_future_slots(socket.assigns.current_user)
      )
      |> assign(waiting_list_slots: WaitingList.list_waiting_list_slots(20))
      |> assign(waiting_list_slots_count: WaitingList.waiting_list_slots_count())

    {:noreply, socket}
  end

  def handle_event(
        "add_route_to_schedule",
        %{"track_route_id" => track_route_id, "loco_id" => loco_id},
        socket
      ) do
    track_route = RailControl.get_track_route!(track_route_id)
    loco = RailControl.get_loco!(loco_id)

    # Set automodetype to 1 (doesn't seem to harm but helps sometimes)
    request_railcontrol_url("cmd=trackstartloco&track=#{loco.track}&automodetype=1")

    # Add the route to the schedule
    request_railcontrol_url(
      "cmd=locoaddtimetable&loco=#{loco.loco_id}&timetable=route#{track_route.route_id}"
    )

    # Set speed to 1 to indicate that the loco is about to move.
    RailControl.update_loco(loco, %{speed: 1})

    socket =
      socket
      |> assign(locos: RailControl.list_locos())

    {:noreply, socket}
  end

  defp request_railcontrol_url(url) do
    case System.cmd("curl", ["-s", "http://10.0.23.2:8082/?#{url}"]) do
      {"", 7} ->
        Logger.debug("RailControl is offline ++++++++++++++++++++++++")
        nil

      _ ->
        Logger.debug("#{url} RailControl ++++++++++++++++++++++++")
        nil
    end
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
