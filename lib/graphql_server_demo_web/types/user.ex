defmodule GraphqlServerDemoWeb.Types.User do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  import_types Absinthe.Type.Custom

  @desc "User contact preferences"
  object :preferences do
    field :id, :id
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :updated_at, :datetime
    field :inserted_at, :datetime
  end

  @desc "A representation of a user"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :updated_at, :datetime
    field :inserted_at, :datetime
    field :preferences, :preferences, resolve: dataloader(GraphqlServerDemo.Accounts)
  end
end
