defmodule Animina.Factory do
  use ExMachina.Ecto, repo: Animina.Repo

  def user_factory do
    %Animina.Accounts.User{
      first_name: "John",
      last_name: "Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
      username: sequence(:username, &"username-#{&1}"),
      gender: sequence(:gender, ["male", "female", "other", "prefer not to say"]),
      birthday: ~D[2000-01-01],
      password: "LeastSecurePasswordEver",
      hashed_password: Bcrypt.hash_pwd_salt("LeastSecurePasswordEver"),
      lang: "en",
      timezone: "Europe/Berlin",
      coupon_code: CouponCode.generate()
    }
  end

  def room_factory do
    name = sequence(:name, &"Room#{&1}")
    slug = name |> String.downcase()

    %Animina.Chats.Room{
      name: name,
      slug: slug
    }
  end

  def message_factory do
    %Animina.Chats.Message{
      content: sequence(:content, &"Test message #{&1}"),
      user: build(:user),
      room: build(:room)
    }
  end

  def transfer_factory do
    %Animina.Points.Transfer{
      amount: 100,
      receiver: build(:user)
    }
  end

  def track_plan_factory(attrs \\ %{}) do
    name = sequence(:name, &"Track#{&1}")
    slug = name |> String.downcase()

    %Animina.Trains.TrackPlan{
      name: name,
      slug: slug
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def team_factory(attrs \\ %{}) do
    name = sequence(:name, &"Team#{&1}")
    slug = name |> String.downcase()

    %Animina.Games.Team{
      name: name,
      slug: slug,
      owner: build(:user)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def team_membership_factory(attrs \\ %{}) do
    %Animina.Games.TeamMembership{
      user: build(:user),
      team: build(:team)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def package_factory(attrs \\ %{}) do
    name = sequence(:name, &"Package#{&1}")

    %Animina.Offers.Package{
      active: true,
      includes_appointment: false,
      locos: 1,
      players: 1,
      points: 200,
      seconds: 60,
      stations: 3,
      name: name
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def slot_factory(attrs \\ %{}) do
    %Animina.WaitingList.Slot{
      team: build(:team),
      package: build(:package)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def loco_factory(attrs \\ %{}) do
    loco_id = sequence(:loco_id, &"#{&1}")
    name = sequence(:name, &"Loco#{&1}")

    %Animina.RailControl.Loco{
      loco_id: loco_id,
      name: name
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  Animina.RailControl.LocoDataPoint

  def loco_data_point_factory(attrs \\ %{}) do
    %Animina.RailControl.LocoDataPoint{
      direction: 1,
      speed: 500,
      track: 1,
      loco: build(:loco)
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end

  def track_route_factory(attrs \\ %{}) do
    name = sequence(:name, &"Track#{&1}")

    %Animina.RailControl.TrackRoute{
      route_id: 1,
      start_track: 1,
      start_direction: 1,
      destination_track: 2,
      destination_direction: 1,
      name: name
    }
    |> merge_attributes(attrs)
    |> evaluate_lazy_attributes()
  end
end
