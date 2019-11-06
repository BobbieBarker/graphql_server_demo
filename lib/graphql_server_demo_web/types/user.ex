defmodule GraphqlServerDemoWeb.Types.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import_types Absinthe.Type.Custom

  @desc "User contact preferences"
  object :preferences do
    field :id, :id
    field :likes_emails, :boolean, description: "The users email contact preference"
    field :likes_phone_calls, :boolean, description: "The users phone contact preference"
    field :updated_at, :datetime , description: "The last time the users account record was updated"
    field :inserted_at, :datetime, description: "When the user's account was created"
  end

  @desc "A representation of a user"
  object :user do
    field :id, :id
    field :name, :string, description: "The user's name"
    field :email, :string, description: "The users's email"
    field :updated_at, :datetime, description: "Indicates the last time the user's account was updated"
    field :inserted_at, :datetime, description: "Indicates when the user's account was created"
    field :preferences, :preferences, resolve: dataloader(GraphqlServerDemo.Accounts), description: "Used to track acceptable forms of contacting the user"
  end
end
