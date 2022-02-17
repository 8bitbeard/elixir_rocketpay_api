# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rocketpay,
  ecto_repos: [Rocketpay.Repo]

# Configures the endpoint
config :rocketpay, RocketpayWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RocketpayWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Rocketpay.PubSub,
  live_view: [signing_salt: "6P2dOO6i"]

config :rocketpay, Rocketpay.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :rocketpay, RocketpayWeb.Auth.Guardian,
  issuer: "rocketpay",
  secret_key: "HGr3m4S9/UtVlhV04PVdPQAis5Ygj8L7FYk45a8yh6HO3FtqiRHpLOInEXQifxf7"

config :rocketpay, RocketpayWeb.Auth.Pipeline,
  module: RocketpayWeb.Auth.Guardian,
  error_handler: RocketpayWeb.Auth.ErrorHandler

# config :rocketpay, :basic_auth,
#   username: "banana",
#   password: "nanica123"

config :rocketpay, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: RocketpayWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: RocketpayWeb.Endpoint
    ]
  }

config :rocketpay, RocketpayWeb.Endpoint, url: [host: "localhost"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :rocketpay, Rocketpay.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
