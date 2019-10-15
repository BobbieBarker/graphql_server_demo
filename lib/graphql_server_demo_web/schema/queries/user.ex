defmodule GraphqlServerDemoWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation

  alias GraphqlServerDemoWeb.Resolvers

  object :user_queries do
    field :user, :user do
      arg :id, non_null(:id)

      resolve &Resolvers.User.find/2
    end

    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :name, :string
      arg :first, :integer
      arg :after, :integer
      arg :before, :integer
      resolve &Resolvers.User.all/2
    end
  end
end



