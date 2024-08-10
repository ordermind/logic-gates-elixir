defmodule OrGate do
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
        {:error, reason}

      other ->
        {:error,
         "When a function is passed as a value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def exec([head | _]) do
    {:error,
     "Each input value for an OR gate must be either a function or a boolean. Current value: #{inspect(head)}"}
  end

  def exec([]) do
    {:ok, false}
  end

  def exec(input) do
    {:error, "The value of an OR gate must be a list. Current value: #{inspect(input)}"}
  end
end
