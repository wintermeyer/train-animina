defmodule Animina.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Animina.Repo,
      # Start the Telemetry supervisor
      AniminaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Animina.PubSub},
      # Start the Endpoint (http/https)
      AniminaWeb.Endpoint,
      # Start a worker by calling: Animina.Worker.start_link(arg)
      # {Animina.Worker, arg}
      Animina.Presence,
      # Cronjob solution
      Animina.RecurrentRunner
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Animina.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AniminaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
