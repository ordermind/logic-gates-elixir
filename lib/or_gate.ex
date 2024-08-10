defmodule LogicGates.OrGate do
  @doc ~S"""
  Executes an OR gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason string or atom.

  An OR gate returns true if at least one of the input values is true. For performance reasons the values are evaluated
  sequentially and the execution stops as soon as a `true` value is found. This means that any errors later in the list
  are not found:

  iex> LogicGates.OrGate.exec([true, :error])
  {:ok, :true}

  ## Truth table with three input values

      iex> LogicGates.OrGate.exec([false, false, false])
      {:ok, :false}

      iex> LogicGates.OrGate.exec([false, false, true])
      {:ok, :true}

      iex> LogicGates.OrGate.exec([false, true, false])
      {:ok, :true}

      iex> LogicGates.OrGate.exec([false, true, true])
      {:ok, :true}

      iex> LogicGates.OrGate.exec([true, false, false])
      {:ok, :true}

      iex> LogicGates.OrGate.exec([true, false, true])
      {:ok, :true}

      iex> LogicGates.OrGate.exec([true, true, false])
      {:ok, :true}

      iex> LogicGates.OrGate.exec([true, true, true])
      {:ok, :true}

  """
  @spec exec(list()) :: {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec([head | tail]) when is_boolean(head) do
    case head do
      true -> {:ok, true}
      false -> exec(tail)
    end
  end

  def exec([head | tail]) when is_function(head) do
    case head.() do
      {:ok, true} ->
        {:ok, true}

      {:ok, false} ->
        exec(tail)

      {:error, reason} ->
        {:error,
         "Error in LogicGates.OrGate.exec/1: an error was returned by a function input value: #{inspect(reason)}"}

      other ->
        {:error,
         "Error in LogicGates.OrGate.exec/1: when a function is passed as an input value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def exec([head | _]) do
    {:error,
     "Error in LogicGates.OrGate.exec/1: each input value for an OR gate must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  def exec([]) do
    {:ok, false}
  end

  def exec(input) do
    {:error,
     "Error in LogicGates.OrGate.exec/1: the value of an OR gate must be a list. Current value: #{inspect(input)}"}
  end
end
