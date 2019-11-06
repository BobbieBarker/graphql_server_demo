use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_server_demo, GraphqlServerDemoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn


config :graphql_server_demo, GraphqlServerDemo.Repo,
  database: "graphql_server_demo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :graphql_server_demo,
  ecto_repos: [GraphqlServerDemo.Repo]

config :ecto_shorts,
  repo: GraphqlServerDemo.Repo,
  error_module: EctoShorts.Actions.Error
