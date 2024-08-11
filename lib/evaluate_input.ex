defmodule LogicGates.EvaluateInput do
  @moduledoc false

  # Iterates and evaluates the input and counts the true and false values
  @spec count_values(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))) ::
          {:ok, %{true: integer(), false: integer()}} | {:error, binary()}
  def count_values(input, counter \\ %{true: 0, false: 0})

  def count_values([head | tail], counter) when is_boolean(head) do
    case head do
      true -> count_values(tail, %{true: counter.true + 1, false: counter.false})
      false -> count_values(tail, %{true: counter.true, false: counter.false + 1})
    end
  end

  def count_values([head | tail], counter) when is_function(head) do
    case head.() do
      {:ok, true} ->
        count_values(tail, %{true: counter.true + 1, false: counter.false})

      {:ok, false} ->
        count_values(tail, %{true: counter.true, false: counter.false + 1})

      {:error, reason} ->
        {:error, "An error was returned by a function input value: #{inspect(reason)}"}

      other ->
        {:error,
         "When a function is passed as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def count_values([head | _], _) do
    {:error,
     "Each input value must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  # This is the final iteration where there are no more input values to evalute. There have been no errors so
  # we return the filled up counter.
  def count_values([], counter) do
    {:ok, counter}
  end
end
