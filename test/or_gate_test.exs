defmodule OrGateTest do
  use ExUnit.Case
  doctest LogicGates.OrGate
  alias LogicGates.OrGate

  test "exec/1 returns error on invalid input type" do
    [
      true,
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_input ->
      assert(
        OrGate.exec(invalid_input) ==
          {:error,
           "Error in LogicGates.OrGate.exec/1: the value of an OR gate must be a list. Current value: #{inspect(invalid_input)}"}
      )
    end)
  end

  test "exec/1 returns error on invalid type of value in input list" do
    [
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_value ->
      assert(
        OrGate.exec([invalid_value]) ==
          {:error,
           "Error in LogicGates.OrGate.exec/1: each input value for an OR gate must be either a function or a boolean. Current value: #{inspect(invalid_value)}"}
      )
    end)
  end

  test "exec/1 returns error on invalid return type of function value" do
    [
      true,
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_return_value ->
      assert(
        OrGate.exec([fn -> invalid_return_value end]) ==
          {:error,
           "Error in LogicGates.OrGate.exec/1: when a function is passed as an input value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is return from a function input value" do
    assert(
      OrGate.exec([fn -> {:error, "Test error"} end]) ==
        {:error,
         "Error in LogicGates.OrGate.exec/1: an error was returned by a function input value: \"Test error\""}
    )
  end

  test "exec/1 returns false on empty list input" do
    assert OrGate.exec([]) == {:ok, false}
  end

  test "exec/1 boolean input" do
    # This is covered by the doctests
  end

  test "exec/1 function input" do
    [
      {[false, false, false], {:ok, false}},
      {[false, false, true], {:ok, true}},
      {[false, true, false], {:ok, true}},
      {[false, true, true], {:ok, true}},
      {[true, false, false], {:ok, true}},
      {[true, false, true], {:ok, true}},
      {[true, true, false], {:ok, true}},
      {[true, true, true], {:ok, true}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        OrGate.exec(
          Enum.map(
            return_values,
            fn return_value ->
              fn -> {:ok, return_value} end
            end
          )
        ) == expected_output
      )
    end)
  end
end
