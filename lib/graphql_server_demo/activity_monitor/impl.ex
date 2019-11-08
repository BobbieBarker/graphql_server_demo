defmodule GraphqlServerDemo.ActivityMonitor.Impl do
  @moduledoc """
    Implements the business logic of updating and fetching
    the state for our ActivityMonitor.Agent
  """

  @doc ~S"""
    Increments the value of the specified key if it exists.
    If the supplied key does not we return the state unaltered.

    ## Example

      iex> GraphqlServerDemo.ActivityMonitor.Impl.update(%{"foo" => 0}, "foo")
      %{"foo" => 1}

      iex> GraphqlServerDemo.ActivityMonitor.Impl.update(%{"foo" => 0}, "bar")
      %{"foo" => 0}
  """
  def update(state, key) do
    if Map.has_key?(state, key) do
      Map.update(state, key, 0, &(&1 + 1))
    else
      state
    end
  end

  @doc ~S"""
    Returns {:ok, key_value} if the target key exists in the state map.
    If not :error is returned

    iex> GraphqlServerDemo.ActivityMonitor.Impl.fetch(%{"foo" => 0}, "foo")
    {:ok, 0}

    iex> GraphqlServerDemo.ActivityMonitor.Impl.fetch(%{"foo" => 0}, "bar")
    :error
  """
  def fetch(state, key) do
    Map.fetch(state, key)
  end
end
