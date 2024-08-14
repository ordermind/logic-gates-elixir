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

  @spec exec([boolean() | (-> {:ok, boolean()} | {:error, any()})]) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec(input) when not is_list(input) do
    {:error,
     "The parameter to LogicGates.And.exec/1 must be a list. Current parameter: #{inspect(input)}"}
  end

  def exec(input) when length(input) < 1 do
    {:error, "LogicGates.And.exec/1 requires the input list to contain at least one element."}
  end

  def exec(input) do
    case EvaluateInput.count_values(input, "LogicGates.And.exec/1") do
      {:ok, counter} -> {:ok, counter.false == 0}
      {:error, reason} -> {:error, reason}
    end
  end
end
