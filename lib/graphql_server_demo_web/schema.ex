defmodule GraphqlServerDemoWeb.Schema do
  use Absinthe.Schema

  alias GraphqlServerDemoWeb.Schema

  import_types GraphqlServerDemoWeb.Types.User
  import_types Schema.Queries.User
  import_types Schema.Mutations.User
  import_types Schema.Subscriptions.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(GraphqlServerDemo.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), GraphqlServerDemo.Accounts, source)

    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
