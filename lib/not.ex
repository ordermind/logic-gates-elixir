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
          | (-> {:ok, boolean()} | {:error, any()})
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

      {:error, reason} when is_binary(reason) ->
        {:error, reason}

      {:error, reason} ->
        {:error, inspect(reason)}

      other ->
        {:error,
         "When a function is passed as a parameter to LogicGates.Not.exec/1, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def exec(input) do
    {:error,
     "The parameter to LogicGates.Not.exec/1 must be either a boolean or a function. Current parameter: #{inspect(input)}"}
  end
end
