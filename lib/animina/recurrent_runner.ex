defmodule Animina.RecurrentRunner do
  use GenServer
  require Logger
  alias Animina.RailControl
  alias Animina.Repo

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    fetch_track_routes_from_railcontrol()

    :timer.send_interval(1_000, :work_every_second)
    :timer.send_interval(120_000, :work_every_two_minutes)

    {:ok, state}
  end

  @impl true
  def handle_info(:work_every_second, state) do
    do_every_second_recurrent_thing(state)
    {:noreply, state}
  end

  @impl true
  def handle_info(:work_every_two_minutes, state) do
    do_every_two_minutes_recurrent_thing(state)
    {:noreply, state}
  end

  defp do_every_second_recurrent_thing(_state) do
    fetch_locos_from_railcontrol()
    Animina.WaitingList.manage_current_slot()

    Phoenix.PubSub.broadcast(
      Animina.PubSub,
      "active-slot-channel",
      {:update_remaining_lifetime}
    )

    Phoenix.PubSub.broadcast(
      Animina.PubSub,
      "waiting-list",
      {:update_waitinglist}
    )
  end

  defp do_every_two_minutes_recurrent_thing(_state) do
    Animina.Points.deal_out_free_points_to_current_users()
  end

  def fetch_locos_from_railcontrol() do
    # Get locomotives
    #
    # LokID;Geschwindigkeit;Fahrtrichtung;Gleis(0=kein Gleis);Name
    case System.cmd("curl", ["-s", "http://10.0.23.2:8082/?cmd=getlocolist"]) do
      {"", 7} ->
        Logger.debug("RailControl is offline ++++++++++++++++++++++++")

      {body, 0} ->
        lines = String.split(body, "\n")

        for line <- lines do
          case String.split(line, ";") do
            [loco_id, speed, direction, track, name] ->
              loco = RailControl.find_or_create_loco(%{name: name, loco_id: loco_id})

              data_point = Animina.RailControl.get_last_data_point_for_loco(loco)

              if data_point == nil || data_point.speed != String.to_integer(speed) ||
                   data_point.direction != String.to_integer(direction) ||
                   data_point.track != String.to_integer(track) do
                {:ok, _loco} =
                  RailControl.create_loco_data_point(%{
                    loco_id: loco.id,
                    speed: speed,
                    direction: direction,
                    track: track
                  })
              end

            _ ->
              nil
          end
        end

        Phoenix.PubSub.broadcast(
          Animina.PubSub,
          "active-slot-channel",
          {:update_locos}
        )

      _ ->
        nil
    end
  end

  def fetch_track_routes_from_railcontrol() do
    # Get routes
    #
    # FahrstrassenID;VonGleis;VonRichtung;NachGleis;NachRichtung;Name

    case System.cmd("curl", ["-s", "http://10.0.23.2:8082/?cmd=getroutelist"]) do
      {"", 7} ->
        Logger.debug("RailControl is offline ++++++++++++++++++++++++")

      {body, 0} ->
        lines = String.split(body, "\n")

        if length(lines) > 0 do
          # Delete old data
          Repo.delete_all(RailControl.TrackRoute)

          # Fill up with new data
          for line <- lines do
            case String.split(line, ";") do
              [
                route_id,
                start_track,
                start_direction,
                destination_track,
                destination_direction,
                name
              ] ->
                case RailControl.create_track_route(%{
                       route_id: route_id,
                       start_track: start_track,
                       start_direction: start_direction,
                       destination_track: destination_track,
                       destination_direction: destination_direction,
                       name: name
                     }) do
                  {:error, _} -> nil
                  _ -> nil
                end

              _ ->
                nil
            end
          end
        end

      _ ->
        nil
    end
  end
end
