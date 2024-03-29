defmodule GraphqlServerDemoWeb.Schema.Queries.UserTest do
  use GraphqlServerDemoWeb.Support.DataCase, async: false

  alias GraphqlServerDemoWeb.Schema

  import GraphqlServerDemoWeb.Support.Fixtures.User, only: [setup_users: 1]

  @all_users_doc"""
    query allUsers(
      $after: Int,
      $before: Int,
      $first: Int,
      $likesEmails: Boolean,
      $likesPhoneCalls: Boolean,
      $name: String
    ) {
    users(
      after: $after,
      before: $before,
      first: $first,
      likesEmails: $likesEmails,
      likesPhoneCalls: $likesPhoneCalls,
      name: $name
    ) {
      name
      email
      id
      preferences {
        likesEmails
        likesPhoneCalls
      }
    }
  }
  """

  @user"""
    query findById($id: ID){
      user(id: $id){
        name
        email
        id
        preferences{
          likesEmails
          likesPhoneCalls
        }
      }
    }
  """

  describe "@users" do
    setup [:setup_users]

    test "fetches all the users", %{user1: user1, user2: user2} do
      # WIP write support function that reduces this Absinthe.run boilerplate
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{}
      )

      assert List.first(data["users"])["id"] === to_string(user1.id)
      assert Enum.at(data["users"], 1)["id"] === to_string(user2.id)
    end

    test "After returns all the items after the target ID", %{user1: user1, user2: user2} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{"after" => user1.id}
      )
      assert length(data["users"]) === 1
      assert List.first(data["users"])["id"] === to_string(user2.id)
    end

    test "Before returns all the items before the target ID", %{user1: user1, user2: user2} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{"before" => user2.id}
      )
      assert length(data["users"]) === 1
      assert List.first(data["users"])["id"] === to_string(user1.id)
    end

    test "First returns the first n items", %{user1: user1} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{"first" => 1}
      )
      assert length(data["users"]) === 1
      assert List.first(data["users"])["id"] === to_string(user1.id)
    end

    test "likesEmails filters users by likesEmail preference", %{user1: user1} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{"likesEmails" => true}
      )

      assert length(data["users"]) === 1
      assert List.first(data["users"])["id"] === to_string(user1.id)
    end

    test "likesPhoneCalls filters users by likesPhoneCalls preference", %{user1: user1} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{"likesPhoneCalls" => true}
      )
      assert length(data["users"]) === 1
      assert List.first(data["users"])["id"] === to_string(user1.id)
    end

    test "Filter by name", %{user1: user1} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @all_users_doc,
        Schema,
        variables: %{"name" => "great name"}
      )

      assert List.first(data["users"])["id"] === to_string(user1.id)
    end
  end

  describe "@user" do
    setup [:setup_users]

    test "finds a user by id", %{user1: user1} do
      assert {:ok, %{data: data}} = Absinthe.run(
        @user,
        Schema,
        variables: %{"id" => user1.id}
      )

      assert data["user"]["id"] === to_string(user1.id)
    end

    test "returns an error for users that don't exist" do
      assert {:ok, %{data: data, errors: errors}} = Absinthe.run(
        @user,
        Schema,
        variables: %{"id" => 0}
      )

      assert is_nil(data["user"]) === true
      assert List.first(errors).code === :not_found
    end
  end
end
