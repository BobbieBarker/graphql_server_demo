defmodule GraphqlServerDemo.ActivityMonitor.Agent do
  use Agent
  alias GraphqlServerDemo.ActivityMonitor.Impl
  alias GraphqlServerDemo.ActivityMonitor.ResolverActivity
  @default_name ActivityMonitorAgent

  @moduledoc """
    Monitors the activity of specified graphql resolvers
  """

  def start_link(opts \\ []) do

    initial_state = %{
      "find" => 0,
      "update" => 0,
      "all" => 0,
      "update_user_preferences" => 0,
      "create_user" => 0,
    }
    opts = Keyword.put_new(opts, :name, @default_name)

    Agent.start_link(fn -> initial_state end, opts)
  end

  # client
  def update_resolver_activity(name \\ @default_name, key) do
    Agent.cast(name, fn state -> Impl.update(state, key) end)
  end

  # server
  @spec fetch_resolver_activity(atom | pid | {atom, any} | {:via, atom, any}, any) :: any
  def fetch_resolver_activity(name \\ @default_name, key) do
    Agent.get(name, fn state -> Impl.fetch(state, key) end)
  end
end
