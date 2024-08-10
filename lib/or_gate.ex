defmodule OrGate do
  @spec run(list()) :: {:ok, boolean()} | {:error, binary()}
  def run(input)

  def run([head | tail]) when is_boolean(head) do
    case head do
      true -> {:ok, true}
      false -> run(tail)
    end
  end

  def run([head | tail]) when is_function(head) do
    case head.() do
      {:ok, true} ->
        {:ok, true}

      {:ok, false} ->
        run(tail)

      {:error, reason} ->
        {:error, reason}

      other ->
        {:error,
         "When a function is passed as a value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(other)}"}
    end
  end

  def run([]) do
    {:ok, false}
  end

  def run(input) do
    {:error, "The value of an OR gate must be a list. Current value: #{inspect(input)}"}
  end
end
