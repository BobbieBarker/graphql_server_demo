defmodule GraphqlServerDemo.Repo do
  use Ecto.Repo,
    otp_app: :graphql_server_demo,
    adapter: Ecto.Adapters.Postgres
end
