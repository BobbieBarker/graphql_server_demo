defmodule GraphqlServerDemoWeb.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias GraphqlServerDemo.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import GraphqlServerDemoWeb.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(GraphqlServerDemo.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(GraphqlServerDemo.Repo, {:shared, self()})
    end

    :ok
  end
end
