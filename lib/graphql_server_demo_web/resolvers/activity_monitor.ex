defmodule GraphqlServerDemoWeb.Resolvers.ActivityMonitor do
  alias GraphqlServerDemo.ActivityMonitor.Agent, as: ActivityMonitor

  def find(%{key: key}, _) do
    with {:ok, count} <- ActivityMonitor.fetch_resolver_activity(key) do
      {:ok, count}
    else
      :error -> {:error, "Requested key: #{key} is invalid"}
    end

  end
end
