defmodule LogicGates.And do
  @doc ~S"""
  Executes an AND gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason.

  An AND gate returns true if all of the input values evaluate to true. Otherwise it returns false.

  If any input value function returns an error on evaluation, this function will return an error.

  ## Truth table with three input values

      iex> LogicGates.And.exec([false, false, false])
      {:ok, :false}

      iex> LogicGates.And.exec([false, false, true])
      {:ok, :false}

      iex> LogicGates.And.exec([false, true, false])
      {:ok, :false}

      iex> LogicGates.And.exec([false, true, true])
      {:ok, :false}

      iex> LogicGates.And.exec([true, false, false])
      {:ok, :false}

      iex> LogicGates.And.exec([true, false, true])
      {:ok, :false}

      iex> LogicGates.And.exec([true, true, false])
      {:ok, :false}

      iex> LogicGates.And.exec([true, true, true])
      {:ok, :true}

  """
  alias LogicGates.EvaluateInput

  @spec exec(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec(input) when not is_list(input) do
    {:error,
     "Error in LogicGates.And.exec/1: The parameter to the function must be a list. Current parameter: #{inspect(input)}"}
  end

  def exec(input) when length(input) < 1 do
    {:error, "Error in LogicGates.And.exec/1: An AND gate requires at least one input value."}
  end

  def exec(input) do
    case EvaluateInput.count_values(input) do
      {:ok, counter} -> {:ok, counter.false == 0}
      {:error, reason} -> {:error, "Error in LogicGates.And.exec/1: #{reason}"}
    end
  end
end
