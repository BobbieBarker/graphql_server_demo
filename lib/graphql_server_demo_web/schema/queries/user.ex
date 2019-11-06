defmodule GraphqlServerDemoWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation

  alias GraphqlServerDemoWeb.Resolvers

  object :user_queries do
    field :user, :user, description: "Get user by Id" do
      middleware GraphqlServerDemoWeb.Middleware.IdToIntegerConverter
      arg :id, non_null(:id), description: "User Id"

      resolve &Resolvers.User.find/2
    end

    field :users, list_of(:user), description: "List all or filtered users" do
      arg :likes_emails, :boolean, description: "Filters users based on the user's email preference."
      arg :likes_phone_calls, :boolean, description: "Filters users based on the user's phone preference."
      arg :name, :string, description: "Filters users based on their name."
      arg :first, :integer, description: "The next X users."
      arg :after, :integer, description: "Users occuring after the supplied user id"
      arg :before, :integer, description: "Users occuring before the supplied user id"
      resolve &Resolvers.User.all/2
    end
  end
end



