defmodule GraphqlServerDemoWeb.Schema.Mutations.UserTest do
  use GraphqlServerDemoWeb.Support.DataCase, async: true

  alias GraphqlServerDemoWeb.Schema
  alias GraphqlServerDemo.Accounts
  alias GraphqlServerDemo.Repo

  import GraphqlServerDemoWeb.Support.Fixtures.User, only: [setup_user: 1]

    @create_user"""
      mutation createUser(
        $name: String,
        $email: String,
        $likesEmails: Boolean,
        $likesPhoneCalls: Boolean
      ) {
        createUser(
          name: $name,
          email: $email,
          preferences: {
            likesEmails: $likesEmails,
            likesPhoneCalls: $likesPhoneCalls
            }
        ) {
          id
          name
          email
          preferences {
            likesEmails
            likesPhoneCalls
          }
        }
      }
    """

  describe "@createUser" do
    test "creates a user" do
      assert {:ok, %{data: %{"createUser" => %{"id" => new_id}}}} = Absinthe.run(
        @create_user,
        Schema,
        variables: %{"name" => "great name", "email" => "email@email.com"}
      )

      assert {:ok, found_user} = Accounts.find_user(%{id: new_id})
      assert to_string(found_user.id) === new_id
    end

    test "rejects an invalid payload" do
      assert {:ok, %{errors: errors}} = Absinthe.run(
        @create_user,
        Schema,
        variables: %{}
      )

      assert List.first(errors).message === "In argument \"name\": Expected type \"String!\", found null."
      assert Enum.at(errors, 1).message === "In argument \"email\": Expected type \"String!\", found null."
    end
  end

  @update_user"""
  mutation updateUser(
    $id: ID,
    $name: String
  ){
    updateUser(
      id: $id,
      name: $name,
    ){
      id
      name
    }
  }
  """

  describe "@updateUser" do
    setup [:setup_user]

    test "updates a user", %{user: user} do
      assert {:ok, %{data: %{"updateUser" => %{"id" => id}}}} = Absinthe.run(
        @update_user,
        Schema,
        variables: %{"id" => user.id, "name" => "updated name"}
      )

      assert {:ok, found_user} = Accounts.find_user(%{id: id})

      assert found_user.name === "updated name"
    end

    test "rejects an invalid payload" do
      assert {:ok, %{errors: errors}} = Absinthe.run(
        @update_user,
        Schema,
        variables: %{}
      )

      assert List.first(errors).message === "In argument \"id\": Expected type \"ID!\", found null."
    end

    test "rejects an invalid user id" do
      assert {:ok, %{errors: errors}} = Absinthe.run(
        @update_user,
        Schema,
        variables: %{"id" => 0, "name" => "updated name"}
      )

      assert List.first(errors).code === :not_found
    end
  end

  @update_user_preferences"""
    mutation updateUserPreferences(
      $userId: ID,
      $likesEmails: Boolean,
      $likesPhoneCalls: Boolean
    ){
      updateUserPreferences(
        userId: $userId,
        likesEmails: $likesEmails,
        likesPhoneCalls: $likesPhoneCalls
      ) {
        id
        likesEmails
        likesPhoneCalls
      }
    }
  """
  describe "@updateUserPreferences" do
    setup [:setup_user]

    test "updates a users preferences", %{user: user} do
      assert {:ok, %{data: %{"updateUserPreferences" => %{"id" => id}}}} = Absinthe.run(
        @update_user_preferences,
        Schema,
        variables: %{"userId" => user.id, "likesEmails" => false}
      )

      assert user_preference = Repo.get_by(Accounts.Preference, id: id)

      assert user_preference.likes_emails === false
    end

    test "rejects an invalid payload" do
      assert {:ok, %{errors: errors}} = Absinthe.run(
        @update_user,
        Schema,
        variables: %{}
      )

      assert List.first(errors).message === "In argument \"id\": Expected type \"ID!\", found null."
    end

    test "returns an error for users that don't exist" do
      assert {:ok, %{errors: errors}} = Absinthe.run(
        @update_user,
        Schema,
        variables: %{"id" => 0}
      )

      assert List.first(errors).code === :not_found
    end
  end
end
