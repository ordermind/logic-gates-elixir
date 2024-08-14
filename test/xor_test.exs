defmodule XorTest do
  use ExUnit.Case
  doctest LogicGates.Xor
  alias LogicGates.Xor

  test "exec/1 returns error on invalid parameter type" do
    [
      true,
      fn -> false end,
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_input ->
      assert(
        Xor.exec(invalid_input) ==
          {:error,
           "Error in LogicGates.Xor.exec/1: The parameter to the function must be a list. Current parameter: #{inspect(invalid_input)}"}
      )
    end)
  end

  test "exec/1 returns error on fewer than 2 input values" do
    [
      [],
      [true]
    ]
    |> Enum.each(fn invalid_input ->
      assert(
        Xor.exec(invalid_input) ==
          {:error,
           "Error in LogicGates.Xor.exec/1: An XOR gate requires at least two input values."}
      )
    end)
  end

  test "exec/1 returns error on invalid type of input value" do
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
        Xor.exec([true, invalid_value]) ==
          {:error,
           "Error in LogicGates.Xor.exec/1: Each input value must be either a function or a boolean. Current value: #{inspect(invalid_value)}"}
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
        Xor.exec([true, fn -> invalid_return_value end]) ==
          {:error,
           "Error in LogicGates.Xor.exec/1: When a function is passed as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is return from a function input value" do
    assert(
      Xor.exec([true, fn -> {:error, "Test error"} end]) ==
        {:error, "Test error"}
    )

    assert(
      Xor.exec([false, fn -> {:error, :test_error} end]) ==
        {:error, ":test_error"}
    )
  end

  test "exec/1 boolean 2 input values" do
    [
      {[false, false], {:ok, false}},
      {[false, true], {:ok, true}},
      {[true, false], {:ok, true}},
      {[true, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Xor.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 3 input values" do
    [
      {[false, false, false], {:ok, false}},
      {[false, false, true], {:ok, true}},
      {[false, true, false], {:ok, true}},
      {[false, true, true], {:ok, false}},
      {[true, false, false], {:ok, true}},
      {[true, false, true], {:ok, false}},
      {[true, true, false], {:ok, false}},
      {[true, true, true], {:ok, true}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Xor.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 function 2 input values" do
    [
      {[false, false], {:ok, false}},
      {[false, true], {:ok, true}},
      {[true, false], {:ok, true}},
      {[true, true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Xor.exec(
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
      {[false, true, true], {:ok, false}},
      {[true, false, false], {:ok, true}},
      {[true, false, true], {:ok, false}},
      {[true, true, false], {:ok, false}},
      {[true, true, true], {:ok, true}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Xor.exec(
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
      {[false, fn -> {:ok, true} end, true], {:ok, false}},
      {[true, fn -> {:ok, false} end, false], {:ok, true}},
      {[true, fn -> {:ok, false} end, true], {:ok, false}},
      {[true, fn -> {:ok, true} end, false], {:ok, false}},
      {[true, fn -> {:ok, true} end, true], {:ok, true}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Xor.exec(input_values) == expected_output)
    end)
  end
end
