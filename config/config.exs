# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :graphql_server_demo, GraphqlServerDemo.Repo,
  database: "postgres",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :graphql_server_demo,
  ecto_repos: [GraphqlServerDemo.Repo]

config :ecto_shorts,
  repo: GraphqlServerDemo.Repo,
  error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :graphql_server_demo, GraphqlServerDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F3URfUeCmPhsQ3mFYHwRKFyjPClNKxNsTKaqR0FcT2aevGIpBBwpOq9st4oOw/E6",
  render_errors: [view: GraphqlServerDemoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: GraphqlServerDemo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
