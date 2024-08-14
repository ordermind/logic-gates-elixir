defmodule LogicGates.Nor do
  @doc ~S"""
  Executes a NOR gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason.

  A NOR gate returns true if all of the input values evaluate to false. Otherwise it returns false.

  If any input value function returns an error on evaluation, this function will return an error.

  ## Truth table with three input values

      iex> LogicGates.Nor.exec([false, false, false])
      {:ok, :true}

      iex> LogicGates.Nor.exec([false, false, true])
      {:ok, :false}

      iex> LogicGates.Nor.exec([false, true, false])
      {:ok, :false}

      iex> LogicGates.Nor.exec([false, true, true])
      {:ok, :false}

      iex> LogicGates.Nor.exec([true, false, false])
      {:ok, :false}

      iex> LogicGates.Nor.exec([true, false, true])
      {:ok, :false}

      iex> LogicGates.Nor.exec([true, true, false])
      {:ok, :false}

      iex> LogicGates.Nor.exec([true, true, true])
      {:ok, :false}

  """

  alias LogicGates.Or

  @spec exec(list(boolean() | (function() -> {:ok, boolean()} | {:error, any()}))) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input) do
    case Or.exec(input) do
      {:ok, output} ->
        {:ok, !output}

      {:error, reason} ->
        {:error, reason |> String.replace("Or", "Nor")}
    end
  end
end
