defmodule GraphqlServerDemo.Accounts  do
  alias GraphqlServerDemo.Accounts.User
  alias EctoShorts.Actions

  @moduledoc """
    Accounts context defines the API for interacting with our internal representation
    of a user account.
  """

  def list_users(%{likes_phone_calls: likes_phone_calls, likes_emails: likes_emails} = params) do
    all_users = Actions.all(
      User.by_preferences(%{likes_phone_calls: likes_phone_calls, likes_emails: likes_emails}),
      Map.drop(params, [:likes_emails, :likes_phone_calls])
    )
    {:ok, all_users}
  end

  def list_users(%{likes_emails: likes_emails} = params) do
    all_users = Actions.all(
      User.by_preferences(%{likes_emails: likes_emails}),
      Map.delete(params, :likes_emails)
    )
    {:ok, all_users}
  end

  def list_users(%{likes_phone_calls: likes_phone_calls} = params) do
    all_users = Actions.all(
      User.by_preferences(%{likes_phone_calls: likes_phone_calls}),
      Map.delete(params, :likes_phone_calls)
    )
    {:ok, all_users}
  end

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

  def update_user_preference(user_id, params) do
    Actions.update(User, user_id, %{preferences: params})
  end

  def create_user(params) do
    Actions.create(User, params)
  end
end
