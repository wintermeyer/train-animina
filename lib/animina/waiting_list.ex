defmodule Animina.WaitingList do
  @moduledoc """
  The WaitingList context.
  """

  import Ecto.Query, warn: false
  alias Animina.Repo

  alias Animina.WaitingList.Slot

  def subscribe() do
    Phoenix.PubSub.subscribe(Animina.PubSub, "waiting-list")
  end

  def unsubscribe() do
    Phoenix.PubSub.unsubscribe(Animina.PubSub, "waiting-list")
  end

  def broadcast(:update_waiting_list) do
    Phoenix.PubSub.broadcast(
      Animina.PubSub,
      "waiting-list",
      {:update_waitinglist}
    )
  end

  def remaining_lifetime(%Animina.WaitingList.Slot{finished_at: nil} = slot) do
    package = Animina.Offers.get_package!(slot.package_id)
    {:ok, now} = DateTime.now("Etc/UTC")
    scheduled_finished_at = NaiveDateTime.add(slot.started_at, package.seconds)

    NaiveDateTime.diff(scheduled_finished_at, now)
  end

  defp next_available_slot() do
    query =
      from s in Slot,
        where: is_nil(s.started_at),
        order_by: s.inserted_at,
        limit: 1

    Repo.one(query)
  end

  def currently_active_slot() do
    query =
      from s in Slot,
        where: not is_nil(s.started_at),
        where: is_nil(s.finished_at),
        limit: 1

    Repo.one(query)
    |> Repo.preload(team: :users)
    |> Repo.preload(team: :owner)
    |> Repo.preload(:package)
  end

  def find_or_create_active_slot() do
    case {currently_active_slot(), next_available_slot()} do
      {nil, nil} ->
        nil

      {nil, next_available_slot} ->
        {:ok, now} = DateTime.now("Etc/UTC")
        {:ok, slot} = update_slot(next_available_slot, %{started_at: now})

        get_slot!(slot.id)
        |> Repo.preload(team: :users)
        |> Repo.preload(team: :owner)
        |> Repo.preload(:package)

      {slot, _} ->
        slot
    end
  end

  def user_member_of_active_slot?(%Animina.Accounts.User{} = user) do
    active_slot = currently_active_slot()

    if active_slot && Enum.member?(active_slot.team.users, user) do
      true
    else
      false
    end
  end

  # Called by a cronjob. Takes care of managing the slots.
  #
  def manage_current_slot() do
    slot = find_or_create_active_slot()

    if slot do
      package = Animina.Offers.get_package!(slot.package_id)
      {:ok, now} = DateTime.now("Etc/UTC")
      should_be_finished_at = NaiveDateTime.add(slot.started_at, package.seconds)

      case NaiveDateTime.compare(
             should_be_finished_at,
             now
           ) do
        :lt ->
          update_slot(slot, %{finished_at: now})
          find_or_create_active_slot()

        _ ->
          slot
      end
    end
  end

  @doc """
  Returns the list of slots.

  ## Examples

      iex> list_slots()
      [%Slot{}, ...]

  """
  def list_slots do
    Repo.all(Slot)
  end

  def list_waiting_list_slots(limit \\ 10_000_000) do
    Slot
    |> where([p], is_nil(p.started_at))
    |> limit(^limit)
    |> Repo.all()
    |> Repo.preload(team: :users)
    |> Repo.preload(team: :owner)
    |> Repo.preload(:package)
  end

  def waiting_list_slots_count() do
    Slot
    |> where([p], is_nil(p.started_at))
    |> Repo.aggregate(:count, :id)
  end

  def list_future_slots(%Animina.Accounts.User{} = user) do
    team_ids = Animina.Games.get_teams_ids(user)

    Slot
    |> where([p], p.team_id in ^team_ids)
    |> where([p], is_nil(p.started_at))
    |> Repo.all()
    |> Repo.preload(team: :users)
    |> Repo.preload(:package)
  end

  def list_future_slots(nil) do
    []
  end

  def slot_start_eta(%Slot{} = slot) do
    buffer = 5

    query =
      from s in Slot,
        where: s.inserted_at < ^slot.inserted_at,
        where: is_nil(s.started_at),
        join: p in assoc(s, :package),
        select: %{seconds: p.seconds}

    seconds_till_waiting_list_eta =
      Repo.all(query)
      |> Enum.reduce(0, fn p, acc -> p[:seconds] + buffer + acc end)

    {:ok, now} = DateTime.now("Etc/UTC")

    DateTime.add(now, seconds_till_waiting_list_eta, :second)
  end

  @doc """
  Gets a single slot.

  Raises `Ecto.NoResultsError` if the Slot does not exist.

  ## Examples

      iex> get_slot!(123)
      %Slot{}

      iex> get_slot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slot!(id), do: Repo.get!(Slot, id)

  @doc """
  Creates a slot.

  ## Examples

      iex> create_slot(%{field: value})
      {:ok, %Slot{}}

      iex> create_slot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slot(attrs \\ %{}) do
    {status, slot} =
      %Slot{}
      |> Slot.changeset(attrs)
      |> Repo.insert()

    case status do
      :ok ->
        team = Animina.Games.get_team!(slot.team_id)
        owner = Animina.Accounts.get_user!(team.owner_id)
        package = Animina.Offers.get_package!(slot.package_id)

        Animina.Points.create_transfer(%{
          amount: package.points * -1,
          receiver_id: owner.id,
          description: "Package #{package.name} (Slot ID #{slot.id})"
        })

        broadcast_slot_update(slot)

        {status, slot}

      status ->
        {status, slot}
    end
  end

  @doc """
  Updates a slot.

  ## Examples

      iex> update_slot(slot, %{field: new_value})
      {:ok, %Slot{}}

      iex> update_slot(slot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slot(%Slot{} = slot, attrs) do
    changeset =
      slot
      |> Slot.changeset(attrs)

    if changeset.valid? do
      team =
        Animina.Games.get_team!(slot.team_id)
        |> Repo.preload(:users)

      for user <- team.users do
        case changeset.changes do
          %{started_at: _started_at} ->
            Phoenix.PubSub.broadcast(
              Animina.PubSub,
              "user-id#{user.id}",
              {:subscribe_active_slot_channel}
            )

          %{finished_at: _finished_at} ->
            Phoenix.PubSub.broadcast(
              Animina.PubSub,
              "user-id#{user.id}",
              {:unsubscribe_active_slot_channel}
            )

          _ ->
            nil
        end
      end
    end

    {status, slot} = Repo.update(changeset)

    if status == :ok do
      broadcast_slot_update(slot)
    end

    {status, slot}
  end

  def broadcast_slot_update(slot) do
    broadcast(:update_waiting_list)

    slot_with_assocciations =
      get_slot!(slot.id)
      |> Repo.preload(team: :users)
      |> Repo.preload(team: :owner)

    for user <- slot_with_assocciations.team.users do
      if length(list_future_slots(user)) == 0 do
        Phoenix.PubSub.broadcast(
          Animina.PubSub,
          "lobby",
          {:unsubscribe_waiting_list, user}
        )
      else
        Phoenix.PubSub.broadcast(
          Animina.PubSub,
          "lobby",
          {:subscribe_waiting_list, user}
        )
      end
    end
  end

  @doc """
  Deletes a slot.

  ## Examples

      iex> delete_slot(slot)
      {:ok, %Slot{}}

      iex> delete_slot(slot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slot(%Slot{} = slot) do
    {status, slot} = Repo.delete(slot)

    broadcast(:update_waiting_list)

    {status, slot}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slot changes.

  ## Examples

      iex> change_slot(slot)
      %Ecto.Changeset{data: %Slot{}}

  """
  def change_slot(%Slot{} = slot, attrs \\ %{}) do
    Slot.changeset(slot, attrs)
  end
end
