defmodule GraphqlServerDemoWeb.SubscriptionCase do

  @moduledoc"""
    Test case for GraphQL subscription
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use GraphqlServerDemoWeb.DataCase, async: true
      use GraphqlServerDemoWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: GraphqlServerDemoWeb.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(GraphqlServerDemoWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
