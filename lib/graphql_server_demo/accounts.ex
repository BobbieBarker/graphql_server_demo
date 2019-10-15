defmodule GraphqlServerDemo.Accounts  do
  alias GraphqlServerDemo.Accounts.User
  alias EctoShorts.Actions
  def list_users(params \\ %{}) do
    all_users = Actions.all(User, params)
    {:ok, all_users}
  end

  def find_user(params) do
    Actions.find(User, params)
  end

  def update_user(id, params) do
    Actions.update(User, id, params)
  end

  # needs to exit with a status tuple
  def update_user_preference(user_id, params) do
    Actions.update(User, user_id, %{preferences: params})
  end

  def create_user(params) do
    Actions.create(User, params)
  end
end
