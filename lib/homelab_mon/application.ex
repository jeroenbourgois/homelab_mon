defmodule HomelabMon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # HomelabMon.Repo,
      # Start the Telemetry supervisor
      HomelabMonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HomelabMon.PubSub},
      # Start the Endpoint (http/https)
      HomelabMonWeb.Endpoint,
      # Start a worker by calling: HomelabMon.Worker.start_link(arg)
      {HomelabMon.Daemon, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HomelabMon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HomelabMonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
