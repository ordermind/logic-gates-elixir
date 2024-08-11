defmodule LogicGates.Xor do
  @doc ~S"""
  Executes an XOR gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason (see typespec).

  An XOR gate requires at least 2 input values.

  An XOR gate returns true if one input value evaluates to true and the other input value evaluates to false. If the number of input values for the XOR gate is greater than 2, it behaves as a cascade of 2-input gates and performs an odd-parity function. In effect that means that the output of the XOR gate is true if the number of true input values is odd, otherwise the output is false. This can lead to some confusion in cases such as this:

  iex> LogicGates.Xor.exec([true, true, true])
  {:ok, :true}

  For that reason it's recommended to just stick to two input values.

  ## Truth table with two input values

      iex> LogicGates.Xor.exec([false, false])
      {:ok, :false}

      iex> LogicGates.Xor.exec([false, true])
      {:ok, :true}

      iex> LogicGates.Xor.exec([true, false])
      {:ok, :true}

      iex> LogicGates.Xor.exec([true, true])
      {:ok, :false}

  """

  require Integer

  @spec exec(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec(input) when not is_list(input) do
    {:error,
     "Error in LogicGates.Xor.exec/1: the parameter to the function must be a list. Current parameter: #{inspect(input)}"}
  end

  def exec(input) when length(input) < 2 do
    {:error, "Error in LogicGates.Xor.exec/1: an XOR gate requires at least two input values."}
  end

  def exec([head | tail]) do
    case count_true_values([head | tail]) do
      {:ok, counter} -> {:ok, Integer.is_odd(counter.true)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp count_true_values(input, counter \\ %{true: 0, false: 0})

  defp count_true_values([head | tail], counter) when is_boolean(head) do
    case head do
      true -> count_true_values(tail, %{true: counter.true + 1, false: counter.false})
      false -> count_true_values(tail, %{true: counter.true, false: counter.false})
    end
  end

  defp count_true_values([head | tail], counter) when is_function(head) do
    case head.() do
      {:ok, true} ->
        count_true_values(tail, %{true: counter.true + 1, false: counter.false})

      {:ok, false} ->
        count_true_values(tail, %{true: counter.true, false: counter.false})

      {:error, reason} ->
        {:error,
         "Error in LogicGates.Xor.exec/1: an error was returned by a function input value: #{inspect(reason)}"}

      other ->
        {:error,
         "Error in LogicGates.Xor.exec/1: when a function is passed as an input value to an XOR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  defp count_true_values([head | _], _) do
    {:error,
     "Error in LogicGates.Xor.exec/1: each input value for an XOR gate must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  # This is the final iteration where there are no more input values to evalute. We return the filled up counter.
  defp count_true_values([], counter) do
    {:ok, counter}
  end
end
