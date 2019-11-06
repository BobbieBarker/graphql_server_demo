defmodule GraphqlServerDemoWeb.Schema.Queries.ActivityMonitor do
  use Absinthe.Schema.Notation

  alias GraphqlServerDemoWeb.Resolvers

  object :activity_monitor_queries do
    field :resolver_hits, :integer, description: "The number of times the specified resolver has been used" do
      arg :key, non_null(:string), description: "The name of a resolver"

      resolve &Resolvers.ActivityMonitor.find/2
    end
  end
end
