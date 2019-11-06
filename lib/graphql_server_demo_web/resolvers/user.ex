defmodule GraphqlServerDemoWeb.Resolvers.User do
  alias GraphqlServerDemo.Accounts
  alias GraphqlServerDemo.ActivityMonitor.Agent, as: ActivityMonitor

  @moduledoc """
    This module services graphql queries and mutations for users
    and cordinating business logic.
  """
  def find(%{id: id}, _) do
    ActivityMonitor.update_resolver_activity("find")
    Accounts.find_user(%{id: id})
  end

  def update(%{id: id} = params, _) do
    ActivityMonitor.update_resolver_activity("update")
    Accounts.update_user(id, Map.delete(params, :id))
  end

  def all(params, _) do
    ActivityMonitor.update_resolver_activity("all")
    Accounts.list_users(params)
  end

  def update_user_preferences(%{user_id: id} = params, _) do
    ActivityMonitor.update_resolver_activity("update_user_preferences")

    {:ok, %{preferences: preferences} } = Accounts.update_user_preference(id, Map.delete(params, :user_id))

    {:ok, preferences}
  end

  def create_user(params, _) do
    ActivityMonitor.update_resolver_activity("create_user")
    Accounts.create_user(params)
  end
end
