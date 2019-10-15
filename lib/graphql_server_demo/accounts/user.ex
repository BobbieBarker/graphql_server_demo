defmodule GraphqlServerDemo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlServerDemo.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    has_one :preferences,  GraphqlServerDemo.Accounts.Preference, on_replace: :update
    timestamps()
  end

  @available_fields [:name, :email]

  def create_changeset(params) do
    changeset(%GraphqlServerDemo.Accounts.User{}, params)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> Repo.preload(:preferences)
    |> cast(attrs, @available_fields)
    |> validate_required(@available_fields)
    |> cast_assoc(:preferences)
  end
end
