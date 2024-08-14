defmodule LogicGates.EvaluateInput do
  @moduledoc false

  # Iterates and evaluates the input and counts the true and false values
  @spec count_values(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()})), binary()) ::
          {:ok, %{true: integer(), false: integer()}} | {:error, binary()}
  def count_values(input, caller_name, counter \\ %{true: 0, false: 0})

  def count_values([head | tail], caller_name, counter) when is_boolean(head) do
    case head do
      true -> count_values(tail, caller_name, %{true: counter.true + 1, false: counter.false})
      false -> count_values(tail, caller_name, %{true: counter.true, false: counter.false + 1})
    end
  end

  def count_values([head | tail], caller_name, counter) when is_function(head) do
    case head.() do
      {:ok, true} ->
        count_values(tail, caller_name, %{true: counter.true + 1, false: counter.false})

      {:ok, false} ->
        count_values(tail, caller_name, %{true: counter.true, false: counter.false + 1})

      {:error, reason} when is_binary(reason) ->
        {:error, reason}

      {:error, reason} -> {:error, inspect(reason)}

      other ->
        {:error,
         "When a function is passed to #{caller_name} as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def count_values([head | _], caller_name, _) do
    {:error,
     "Each input value to #{caller_name} must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  # This is the final iteration where there are no more input values to evalute. There have been no errors so
  # we return the filled up counter.
  def count_values([], _, counter) do
    {:ok, counter}
  end
end
