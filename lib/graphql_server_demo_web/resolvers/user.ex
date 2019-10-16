defmodule GraphqlServerDemoWeb.Resolvers.User do
  alias GraphqlServerDemo.Accounts

  def find(%{id: id}, _) do
    Accounts.find_user(%{id: id})
  end

  def update(%{id: id} = params, _) do
    Accounts.update_user(id, Map.delete(params, :id))
  end

  def all(params, _), do: Accounts.list_users(params)

  def update_user_preferences(%{user_id: id} = params, _) do
    {:ok, %{preferences: preferences} }= Accounts.update_user_preference(id, Map.delete(params, :user_id))

    {:ok, preferences}
  end

  def create_user(params, _) do
    Accounts.create_user(params)
  end
end
