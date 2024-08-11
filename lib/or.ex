defmodule LogicGates.Or do
  @doc ~S"""
  Executes an OR gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason string or atom.

  An OR gate returns true if at least one of the input values evaluates to true. Otherwise it returns false.

  For performance reasons the input values are evaluated sequentially and the execution stops as soon as a `true` value
  is found. This means that any errors later in the list are not found:

  iex> LogicGates.Or.exec([true, fn -> {:error, "Test error"} end])
  {:ok, :true}

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
  @spec exec(list()) :: {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec([head | tail]) do
    exec_recursive([head | tail])
  end

  def exec([]) do
    {:error,
     "Error in LogicGates.Or.exec/1: the function was called with an empty list as parameter, so there are no input values to evaluate."}
  end

  def exec(input) do
    {:error,
     "Error in LogicGates.Or.exec/1: the parameter to the function must be a list. Current parameter: #{inspect(input)}"}
  end

  defp exec_recursive(input)

  defp exec_recursive([head | tail]) when is_boolean(head) do
    case head do
      true -> {:ok, true}
      false -> exec_recursive(tail)
    end
  end

  defp exec_recursive([head | tail]) when is_function(head) do
    case head.() do
      {:ok, true} ->
        {:ok, true}

      {:ok, false} ->
        exec_recursive(tail)

      {:error, reason} ->
        {:error,
         "Error in LogicGates.Or.exec/1: an error was returned by a function input value: #{inspect(reason)}"}

      other ->
        {:error,
         "Error in LogicGates.Or.exec/1: when a function is passed as an input value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  defp exec_recursive([head | _]) do
    {:error,
     "Error in LogicGates.Or.exec/1: each input value for an OR gate must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  defp exec_recursive([]) do
    {:ok, false}
  end
end
