defmodule GraphqlServerDemoWeb.Resolvers.ActivityMonitor do
  alias GraphqlServerDemo.ActivityMonitor.Agent, as: ActivityMonitor

  @spec find(%{key: String.t}, any) :: {:ok, integer}
  def find(%{key: key}, _) do
    with :error <- ActivityMonitor.fetch_resolver_activity(key) do
      {:error, "Requested key: #{key} is invalid"}
    end
  end
end
