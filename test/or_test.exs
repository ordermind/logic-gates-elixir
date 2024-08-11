defmodule OrTest do
  use ExUnit.Case
  doctest LogicGates.Or
  alias LogicGates.Or

  test "exec/1 returns error on invalid parameter type" do
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
        Or.exec(invalid_input) ==
          {:error,
           "Error in LogicGates.Or.exec/1: the parameter to the function must be a list. Current parameter: #{inspect(invalid_input)}"}
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
        Or.exec([invalid_value]) ==
          {:error,
           "Error in LogicGates.Or.exec/1: each input value for an OR gate must be either a function or a boolean. Current value: #{inspect(invalid_value)}"}
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
        Or.exec([fn -> invalid_return_value end]) ==
          {:error,
           "Error in LogicGates.Or.exec/1: when a function is passed as an input value to an OR gate, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is return from a function input value" do
    assert(
      Or.exec([false, fn -> {:error, "Test error"} end]) ==
        {:error,
         "Error in LogicGates.Or.exec/1: an error was returned by a function input value: \"Test error\""}
    )
  end

  test "exec/1 returns an error on empty list input" do
    assert(
      Or.exec([]) ==
        {:error,
         "Error in LogicGates.Or.exec/1: the function was called with an empty list as parameter, so there are no input values to evaluate."}
    )
  end

  test "exec/1 boolean 1 input value" do
    [
      {[false], {:ok, false}},
      {[true], {:ok, true}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Or.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 2 input values" do
    [
      {[false, false], {:ok, false}},
      {[false, true], {:ok, true}},
      {[true, false], {:ok, true}},
      {[true, true], {:ok, true}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Or.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 3 input values" do
    # This is covered by the doctests
  end

  test "exec/1 function 1 input value" do
    [
      {[false], {:ok, false}},
      {[true], {:ok, true}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Or.exec(
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

  test "exec/1 function 2 input values" do
    [
      {[false, false], {:ok, false}},
      {[false, true], {:ok, true}},
      {[true, false], {:ok, true}},
      {[true, true], {:ok, true}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Or.exec(
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

  test "exec/1 function 3 input values" do
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
        Or.exec(
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

  test "exec/1 mixed input value types" do
    [
      {[false, fn -> {:ok, false} end, false], {:ok, false}},
      {[false, fn -> {:ok, false} end, true], {:ok, true}},
      {[false, fn -> {:ok, true} end, false], {:ok, true}},
      {[false, fn -> {:ok, true} end, true], {:ok, true}},
      {[true, fn -> {:ok, false} end, false], {:ok, true}},
      {[true, fn -> {:ok, false} end, true], {:ok, true}},
      {[true, fn -> {:ok, true} end, false], {:ok, true}},
      {[true, fn -> {:ok, true} end, true], {:ok, true}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Or.exec(input_values) == expected_output)
    end)
  end
end
