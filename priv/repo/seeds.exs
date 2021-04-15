# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Animina.Repo.insert!(%Animina.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Animina.Chats
alias Animina.Offers

{:ok, _lobby} = Chats.create_room(%{name: "Lobby"})
{:ok, _logged_in_users} = Chats.create_room(%{name: "Logged in users"})

{:ok, _basic} =
  Offers.create_package(%{
    name: "Basic",
    locos: 1,
    players: 1,
    seconds: 60,
    stations: 7,
    points: 200,
    includes_appointment: false,
    active: true
  })

{:ok, _basic_plus} =
  Offers.create_package(%{
    name: "Basic +",
    locos: 1,
    players: 1,
    seconds: 120,
    stations: 7,
    points: 300,
    includes_appointment: false,
    active: true
  })

{:ok, _premium} =
  Offers.create_package(%{
    name: "Premium",
    locos: 2,
    players: 1,
    seconds: 180,
    stations: 10,
    points: 500,
    includes_appointment: false,
    active: true
  })

# {:ok, _group} =
#   Offers.create_package(%{
#     name: "Gold",
#     locos: 3,
#     players: 1,
#     seconds: 240,
#     stations: 10,
#     points: 800,
#     includes_appointment: false,
#     active: true
#   })
