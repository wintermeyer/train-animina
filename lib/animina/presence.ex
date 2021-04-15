defmodule Animina.Presence do
  use Phoenix.Presence,
    otp_app: :real_world_phoenix,
    pubsub_server: Animina.PubSub
end
