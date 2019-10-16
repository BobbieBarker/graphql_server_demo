defmodule GraphqlServerDemoWeb.Middleware.IdToIntegerConverter do
  @moduledoc """
  Middleware for absinthe to format id props to integers
  """

  @behaviour Absinthe.Middleware

  @impl Absinthe.Middleware
  def call(context, _) do
    id_keys = context_id_keys(context)

    convert_context_keys_to_string(context, id_keys)
  end

  defp context_id_keys(%{definition: %{arguments: args}}) do
    args
    |> Enum.filter(&(unwrap_type(&1.schema_node.type) === :id))
    |> Enum.map(&String.to_atom(&1.schema_node.name))
  end

  defp context_id_keys(_) do
    []
  end

  defp unwrap_type(%{of_type: type}) do
    unwrap_type(type)
  end

  defp unwrap_type(type) do
    type
  end

  defp convert_context_keys_to_string(%{arguments: arguments} = context, id_keys) do
    arguments =
      Enum.into(arguments, %{}, fn
        {key, value} ->
          if key in id_keys do
            {key, convert_to_integer(value)}
          else
            {key, value}
          end
      end)

    Map.put(context, :arguments, arguments)
  end

  defp convert_context_keys_to_string(context, _) do
    context
  end

  defp convert_to_integer(value) when is_list(value) do
    Enum.map(value, &convert_to_integer/1)
  end

  defp convert_to_integer(value) do
    with :ok <- check_only_digits(value),
         {int, _} <- Integer.parse(value) do
      int
    else
      :error -> value
    end
  end

  defp check_only_digits(value) do
    if value =~ ~r/^\d+$/ do
      :ok
    else
      :error
    end
  end
end
