# GraphqlServerDemo

## Install and run the server:

* brew install asdf
* asdf plugin-add erlang
* asdf plugin-add elixir
* asdf install erlang 22.0.4
* asdf install elixir 1.9.0-otp-22

## Configure the server:
At this point you'll need to open `config/config.exs` and update the database configuration starting on LOC 10 to valid values for your local database:

```
config :graphql_server_demo, GraphqlServerDemo.Repo,
  database: "your_database_name",
  username: "your_postgres_username",
  password: "your_postgres_password",
  hostname: "localhost"
  ```
Once that is done you'll be able to finish setting up the project and start the server with these commands:

* mix deps.get
* mix ecto.create
* mix ecto.migrate
* iex -S mix phx.server

At this point you should be able to navigate to `http://localhost:4000/graphiql` and explore the graphiql sandbox.