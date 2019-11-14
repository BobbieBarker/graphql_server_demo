defmodule GraphqlServerDemo.ActivityMonitor.AgentTest do
  use ExUnit.Case, async: true
  alias GraphqlServerDemo.ActivityMonitor.Agent, as: ActivityMonitor


  setup do
    {:ok, pid} = ActivityMonitor.start_link([name: nil])

    %{pid: pid}
  end

  describe "&fetch_resolver_activity/2" do
    test "returns the default state for a requested key", %{pid: pid} do
      assert {:ok, 0} = ActivityMonitor.fetch_resolver_activity(pid, "find")
    end

    test "returns an error for an invalid key", %{pid: pid} do
      assert :error = ActivityMonitor.fetch_resolver_activity(pid, "no_exist")
    end
  end

  describe "&update_resolver_activity/2" do
    test "Increments the value of a valid key", %{pid: pid} do
      assert {:ok, 0} = ActivityMonitor.fetch_resolver_activity(pid, "find")
      assert :ok = ActivityMonitor.update_resolver_activity(pid, "find")
      assert {:ok, 1} = ActivityMonitor.fetch_resolver_activity(pid, "find")
    end

    test "Ignores invalid keys", %{pid: pid} do
      assert :ok = ActivityMonitor.update_resolver_activity(pid, "derp")

      assert %{
        "find" => 0,
        "update" => 0,
        "all" => 0,
        "update_user_preferences" => 0,
        "create_user" => 0,
      } = :sys.get_state(pid)
    end
  end
end
