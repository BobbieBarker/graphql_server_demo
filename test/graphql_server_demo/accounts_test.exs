defmodule GraphqlServerDemo.AccountsTests do
  use GraphqlServerDemoWeb.DataCase, async: true

  alias GraphqlServerDemo.Accounts
  alias GraphqlServerDemo.Repo

  describe "&list_users/1" do
    test "lists all users" do
      Repo.insert(%Accounts.User{name: "bob", email: "email@email.com"})
      Repo.insert(%Accounts.User{name: "steve", email: "email2@email.com"})

      assert {:ok, users} = Accounts.list_users()

      assert length(users) === 2
    end
  end

  describe "&find_user/1" do
    test "finds the specified user by id" do
      assert {:ok, %{id: id}} = Repo.insert(%Accounts.User{name: "bob", email: "email@email.com"})

      assert {:ok, %{id: found_id}} = Accounts.find_user(%{id: id})
      assert id === found_id
    end
  end

  describe "&update_user/2" do
    test "updates the specified user by id" do
      assert {:ok, %{id: id}} = Repo.insert(%Accounts.User{name: "bob", email: "email@email.com"})

      assert {:ok, updated_user} = Accounts.update_user(id, %{name: "updated name", email: "updated@email.com"})
      assert updated_user.name === "updated name"
      assert updated_user.email === "updated@email.com"
    end
  end

  describe "&update_user_preferences/2" do
    test "updates a target users preferences" do
      assert {:ok, user} = Repo.insert(%Accounts.User{name: "bob", email: "email@email.com"})

      assert {:ok, _} = Accounts.update_user_preference(user.id, %{likes_emails: true, likes_phone_calls: true})

      assert updated_user = Accounts.User
      |> Repo.get_by(id: user.id)
      |> Repo.preload(:preferences)

      assert updated_user.preferences.likes_emails === true
    end
  end

  describe "&create_user/1" do
    test "creates a record in the db" do
      assert {:ok, derp} = Accounts.create_user(%{name: "bob", email: "email@email.com"})

      assert user = Repo.get_by(Accounts.User, name: "bob")
      assert user.name === "bob"
      assert user.email === "email@email.com"
    end
  end
end
