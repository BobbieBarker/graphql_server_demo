defmodule GraphqlServerDemoWeb.Support.Fixtures.User do
  alias GraphqlServerDemo.Accounts

  def setup_user _context do
    {:ok, user} = Accounts.create_user(%{
      name: "great name",
      email: "email@email.com",
      preferences: %{likes_emails: true, likes_phone_calls: true}
    })

    {:ok, %{user: user}}
  end

  def setup_users _context do
    {:ok, user1} = Accounts.create_user(%{
      name: "great name",
      email: "email@email.com",
      preferences: %{likes_emails: true, likes_phone_calls: true}
    })

    {:ok, user2} = Accounts.create_user(%{
      name: "greater name",
      email: "email2@email.com",
      preferences: %{likes_emails: false, likes_phone_calls: false}
    })
    {:ok, %{user1: user1, user2: user2}}
  end
end
