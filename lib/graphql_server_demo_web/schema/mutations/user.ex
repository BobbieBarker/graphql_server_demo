defmodule GraphqlServerDemoWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation

  alias GraphqlServerDemoWeb.Resolvers

  object :user_mutations do
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      resolve &Resolvers.User.update/2
    end

    field :update_user_preferences, :preferences do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean

      resolve &Resolvers.User.update_user_preferences/2
    end

    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :preferences, :preferences_input

      resolve &Resolvers.User.create_user/2
    end
  end

  input_object :preferences_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
  end
end
