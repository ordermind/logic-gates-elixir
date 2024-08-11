defmodule LogicGates.And do
  @doc ~S"""
  Executes an AND gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason (see typespec).

  An AND gate returns true if all of the input values evaluate to true. Otherwise it returns false.

  For performance reasons the input values are evaluated sequentially and the execution stops as soon as a `false` value
  is found. This means that any errors later in the list are not found:

  iex> LogicGates.And.exec([false, fn -> {:error, "Test error"} end])
  {:ok, :false}

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
  @spec exec(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec([head | tail]) do
    exec_recursive([head | tail])
  end

  def exec([]) do
    {:error,
     "Error in LogicGates.And.exec/1: the function was called with an empty list as parameter, so there are no input values to evaluate."}
  end

  def exec(input) do
    {:error,
     "Error in LogicGates.And.exec/1: the parameter to the function must be a list. Current parameter: #{inspect(input)}"}
  end

  defp exec_recursive(input)

  defp exec_recursive([head | tail]) when is_boolean(head) do
    case head do
      true -> exec_recursive(tail)
      false -> {:ok, false}
    end
  end

  defp exec_recursive([head | tail]) when is_function(head) do
    case head.() do
      {:ok, true} ->
        exec_recursive(tail)

      {:ok, false} ->
        {:ok, false}

      {:error, reason} ->
        {:error,
         "Error in LogicGates.And.exec/1: an error was returned by a function input value: #{inspect(reason)}"}

      other ->
        {:error,
         "Error in LogicGates.And.exec/1: when a function is passed as an input value to an AND gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  defp exec_recursive([head | _]) do
    {:error,
     "Error in LogicGates.And.exec/1: each input value for an AND gate must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  defp exec_recursive([]) do
    {:ok, true}
  end
end
