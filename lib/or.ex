defmodule LogicGates.Or do
  @doc ~S"""
  Executes an OR gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason.

  An OR gate returns true if at least one of the input values evaluates to true. Otherwise it returns false.

  If any input value function returns an error on evaluation, this function will return an error.

  ## Truth table with three input values

      iex> LogicGates.Or.exec([false, false, false])
      {:ok, :false}

      iex> LogicGates.Or.exec([false, false, true])
      {:ok, :true}

      iex> LogicGates.Or.exec([false, true, false])
      {:ok, :true}

      iex> LogicGates.Or.exec([false, true, true])
      {:ok, :true}

      iex> LogicGates.Or.exec([true, false, false])
      {:ok, :true}

      iex> LogicGates.Or.exec([true, false, true])
      {:ok, :true}

      iex> LogicGates.Or.exec([true, true, false])
      {:ok, :true}

      iex> LogicGates.Or.exec([true, true, true])
      {:ok, :true}

  """
  alias LogicGates.EvaluateInput

  @spec exec(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec(input) when not is_list(input) do
    {:error,
     "The parameter to LogicGates.Or.exec/1 must be a list. Current parameter: #{inspect(input)}"}
  end

  def exec(input) when length(input) < 1 do
    {:error, "LogicGates.Or.exec/1 requires the input list to contain at least one element."}
  end

  def exec(input) do
    case EvaluateInput.count_values(input, "LogicGates.Or.exec/1") do
      {:ok, counter} -> {:ok, counter.true > 0}
      {:error, reason} -> {:error, reason}
    end
  end
end
