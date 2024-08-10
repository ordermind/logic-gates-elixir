defmodule OrGateTest do
  use ExUnit.Case
  doctest OrGate

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
      assert OrGate.exec(invalid_input) == {
               :error,
               "The value of an OR gate must be a list. Current value: #{inspect(invalid_input)}"
             }
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
      assert OrGate.exec([invalid_value]) == {
               :error,
               "Each input value for an OR gate must be either a function or a boolean. Current value: #{inspect(invalid_value)}"
             }
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
      assert OrGate.exec([fn -> invalid_return_value end]) == {
               :error,
               "When a function is passed as a value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"
             }
    end)
  end
end
