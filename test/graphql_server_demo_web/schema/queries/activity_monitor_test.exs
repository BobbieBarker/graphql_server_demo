defmodule GraphqlServerDemoWeb.Schema.Queries.ActivityMonitorTest do
  use GraphqlServerDemoWeb.Support.DataCase, async: true

  alias GraphqlServerDemoWeb.Schema

  @resolver_hits"""
    query getResolverHits($key: String){
      resolverHits(key: $key)
    }
  """

  describe "@resolverHits" do
    test "returns the number of times a resolver has been used" do
      assert {:ok, %{data: %{"resolverHits" => count}}} = Absinthe.run(
        @resolver_hits,
        Schema,
        variables: %{"key" => "find"}
      )
      assert count === 0
    end

    test "returns an error when an invalid resolver is requested" do
      assert {:ok, %{data: %{"resolverHits" => count}, errors: errors}} = Absinthe.run(
        @resolver_hits,
        Schema,
        variables: %{"key" => "this_does_not_exist"}
      )
      assert is_nil(count) === true
      assert List.first(errors).message === "Requested key: this_does_not_exist is invalid"
    end
  end
end
