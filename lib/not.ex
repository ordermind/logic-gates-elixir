defmodule LogicGates.Not do
  @doc ~S"""
  Executes an NOT gate on an input which is either a boolean or an anonymous function that returns
  either :ok and a boolean, or :error and a reason. The input can also be a list with exactly one element of the type
  described above.

  An NOT gate returns true if the input value evaluates to false, and vice versa.

  If any input value function returns an error on evaluation, this function will return an error.

  ## Truth table

      iex> LogicGates.Not.exec(false)
      {:ok, :true}

      iex> LogicGates.Not.exec(true)
      {:ok, :false}

  """
  @spec exec(
          boolean()
          | (function() -> {:ok, boolean()} | {:error, any()})
          | list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))
        ) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input)

  def exec(input) when is_boolean(input) do
    {:ok, !input}
  end

  def exec(input) when is_function(input) do
    case input.() do
      {:ok, value} ->
        {:ok, !value}

      {:error, reason} ->
        {:error,
         "Error in LogicGates.Not.exec/1: An error was returned by a function input value: #{inspect(reason)}"}

      other ->
        {:error,
         "Error in LogicGates.Not.exec/1: When a function is passed as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def exec(input) when is_list(input) and length(input) != 1 do
    {:error, "Error in LogicGates.Not.exec/1: An NOT gate requires exactly one input value."}
  end

  def exec([input]) do
    case exec(input) do
      {:ok, value} ->
        {:ok, value}

      {:error, reason} ->
        {:error,
         String.replace(
           reason,
           "The parameter to the function must be either a boolean, a function or a list with exactly one element. Current parameter: ",
           "If a list is passed as a parameter, its single element must be either a boolean or a function. Current element: "
         )}
    end
  end

  def exec(input) do
    {:error,
     "Error in LogicGates.Not.exec/1: The parameter to the function must be either a boolean, a function or a list with exactly one element. Current parameter: #{inspect(input)}"}
  end
end
