defmodule LogicGates.Xor do
  @doc ~S"""
  Executes an XOR gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason.

  An XOR gate requires at least 2 input values.

  An XOR gate returns true if one input value evaluates to true and the other input value evaluates to false. If the number of input values for the XOR gate is greater than 2, it behaves as a cascade of 2-input gates and performs an odd-parity function. In effect that means that the output of the XOR gate is true if the number of true input values is odd, otherwise the output is false. This can lead to some confusion in cases such as this:

      iex> LogicGates.Xor.exec([true, true, true])
      {:ok, :true}

  For that reason it's recommended to just stick to two input values in most cases.

  If any input value function returns an error on evaluation, this function will return an error.

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
  alias LogicGates.EvaluateInput

  @spec exec([boolean() | (-> {:ok, boolean()} | {:error, any()})]) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec(input) when not is_list(input) do
    {:error,
     "The parameter to LogicGates.Xor.exec/1 must be a list. Current parameter: #{inspect(input)}"}
  end

  def exec(input) when length(input) < 2 do
    {:error,
     "LogicGates.Xor.exec/1 requires the input list to contain at least two elements. Current parameter: #{inspect(input)}"}
  end

  def exec(input) do
    case EvaluateInput.count_values(input, "LogicGates.Xor.exec/1") do
      {:ok, counter} -> {:ok, Integer.is_odd(counter.true)}
      {:error, reason} -> {:error, reason}
    end
  end
end
