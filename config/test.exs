import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :homelab_mon, HomelabMon.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "homelab_mon_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :homelab_mon, HomelabMonWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NYx3RuBg2Gp6WrIf9yW60OZjeNq0VURwgK8tv04JXIL0M64a4/8nRwtkprvb9pRg",
  server: false

# In test we don't send emails.
config :homelab_mon, HomelabMon.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
