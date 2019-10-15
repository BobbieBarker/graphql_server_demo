defmodule GraphqlServerDemoWeb.Router do
  use GraphqlServerDemoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: GraphqlServerDemoWeb.Schema

    if Mix.env() === :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: GraphqlServerDemoWeb.Schema,
        socket: GraphqlServerDemoWeb.UserSocket,
        interface: :playground
    end
  end
end
