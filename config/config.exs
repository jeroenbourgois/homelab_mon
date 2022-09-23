# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :homelab_mon,
  env: Mix.env()
#   ecto_repos: [HomelabMon.Repo]

# Configures the endpoint
config :homelab_mon, HomelabMonWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HomelabMonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HomelabMon.PubSub,
  root: ".",
  live_view: [signing_salt: "8hEwkRBb"]

config :homelab_mon, :solar_edge,
  api_key: System.get_env("SOLAR_EDGE_API_KEY") || "",
  api_endpoint: "https://monitoringapi.solaredge.com"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
# config :homelab_mon, HomelabMon.Mailer, adapter: Swoosh.Adapters.Local

config :homelab_mon, HomelabMon.Mailer, 
  adapter: Swoosh.Adapters.Mailgun,
  api_key: System.get_env("MAILGUN_API_KEY") || "",
  domain: System.get_env("MAILGUN_DOMAIN") || "",
  base_url: "https://api.eu.mailgun.net/v3"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  backends: [:console, LogflareLogger.HttpBackend],
  level: :debug,
  utc_log: true

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
