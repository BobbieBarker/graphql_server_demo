defmodule GraphqlServerDemoWeb.Schema.Subscriptions.User do
  use Absinthe.Schema.Notation

  object :user_subscriptions do

    field :created_user, :user do
      trigger :create_user, topic: fn _ ->
        "new user"
      end

      config fn _, _ ->
        {:ok, topic: "new user"}
      end
    end

    field :updated_user_preferences, :preferences do
      arg :user_id, non_null(:id)

      trigger :update_user_preferences, topic: fn %{user_id: user_id} -> user_id end

      config fn args, _ -> {:ok, topic: String.to_integer(args.user_id)} end
    end
  end
end
