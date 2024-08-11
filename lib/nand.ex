defmodule LogicGates.Nand do
  @doc ~S"""
  Executes a NAND gate on an input list. The list may contain either boolean values or anonymous functions that return
  either :ok and a boolean, or :error and a reason string or atom.

  A NAND gate returns true if at least one of the input values evaluates to false. Otherwise it returns false.

  Just like the AND gate, the technical implementation means that errors in function values are not always discovered:

  iex> LogicGates.Nand.exec([false, fn -> {:error, "Test error"} end])
  {:ok, :true}

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

  @spec exec(list()) :: {:ok, boolean()} | {:error, binary()}
  def exec(input) do
    case And.exec(input) do
      {:ok, output} ->
        {:ok, !output}

      {:error, reason} ->
        {:error, reason |> String.replace("And", "Nand") |> String.replace("AND", "NAND")}
    end
  end
end
