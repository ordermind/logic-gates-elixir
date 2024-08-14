defmodule LogicGates.Nand do
  @doc ~S"""
  Executes a NAND gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason.

  A NAND gate returns true if at least one of the input values evaluates to false. Otherwise it returns false.

  If any input value function returns an error on evaluation, this function will return an error.

  ## Truth table with three input values

      iex> LogicGates.Nand.exec([false, false, false])
      {:ok, :true}

      iex> LogicGates.Nand.exec([false, false, true])
      {:ok, :true}

      iex> LogicGates.Nand.exec([false, true, false])
      {:ok, :true}

      iex> LogicGates.Nand.exec([false, true, true])
      {:ok, :true}

      iex> LogicGates.Nand.exec([true, false, false])
      {:ok, :true}

      iex> LogicGates.Nand.exec([true, false, true])
      {:ok, :true}

      iex> LogicGates.Nand.exec([true, true, false])
      {:ok, :true}

      iex> LogicGates.Nand.exec([true, true, true])
      {:ok, :false}

  """
  alias LogicGates.And

  @spec exec([boolean() | (-> {:ok, boolean()} | {:error, any()})]) ::
          {:ok, boolean()} | {:error, binary()}
  def exec(input) do
    case And.exec(input) do
      {:ok, output} ->
        {:ok, !output}

      {:error, reason} ->
        {:error, reason |> String.replace("And", "Nand")}
    end
  end
end
