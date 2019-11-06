defmodule GraphqlServerDemoWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation

  alias GraphqlServerDemoWeb.Resolvers

  object :user_mutations do
    field :update_user, :user do
      middleware GraphqlServerDemoWeb.Middleware.IdToIntegerConverter
      arg :id, non_null(:id), description: "The target users's id"
      arg :name, :string, description: "The user's name"
      arg :email, :string, description: "The user's email"
      resolve &Resolvers.User.update/2
    end

    field :update_user_preferences, :preferences do
      middleware GraphqlServerDemoWeb.Middleware.IdToIntegerConverter
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean, description: "The users email contact preference"
      arg :likes_phone_calls, :boolean, description: "The users phone contact preference"

      resolve &Resolvers.User.update_user_preferences/2
    end

    field :create_user, :user do
      arg :name, non_null(:string), description: "The user's name"
      arg :email, non_null(:string), description: "The user's email"
      arg :preferences, :preferences_input, description: "Used to track acceptable forms of contacting the user"

      resolve &Resolvers.User.create_user/2
    end
  end

  input_object :preferences_input do
    field :likes_emails, :boolean, description: "The users email contact preference"
    field :likes_phone_calls, :boolean, description: "The users phone contact preference"
  end
end
