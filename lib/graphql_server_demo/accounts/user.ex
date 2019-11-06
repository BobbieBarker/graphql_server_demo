defmodule GraphqlServerDemo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias GraphqlServerDemo.Repo
  alias GraphqlServerDemo.Accounts.User

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

  def join_preferences(query \\ User) do
    join(query, :inner, [u], p in assoc(u, :preferences), as: :preferences)
  end

  def by_preferences(query \\ join_preferences(), preferences) do
    Enum.reduce(preferences, query, fn
       {:likes_emails, value}, query_acc -> where(query_acc, [preferences: p], p.likes_emails == ^value)
       {:likes_phone_calls, value}, query_acc -> where(query_acc, [preferences: p], p.likes_phone_calls == ^value)
       _, query_acc -> query_acc
    end)
  end
end
