defmodule NorTest do
  use ExUnit.Case
  doctest LogicGates.Nor
  alias LogicGates.Nor

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
        Nor.exec(invalid_input) ==
          {:error,
           "Error in LogicGates.Nor.exec/1: The parameter to the function must be a list. Current parameter: #{inspect(invalid_input)}"}
      )
    end)
  end

  test "exec/1 returns an error on empty list input" do
    assert(
      Nor.exec([]) ==
        {:error, "Error in LogicGates.Nor.exec/1: An NOR gate requires at least one input value."}
    )
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
        Nor.exec([true, invalid_value]) ==
          {:error,
           "Error in LogicGates.Nor.exec/1: Each input value must be either a function or a boolean. Current value: #{inspect(invalid_value)}"}
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
        Nor.exec([fn -> invalid_return_value end]) ==
          {:error,
           "Error in LogicGates.Nor.exec/1: When a function is passed as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is return from a function input value" do
    assert(
      Nor.exec([true, fn -> {:error, "Test error"} end]) ==
        {:error, "Test error"}
    )

    assert(
      Nor.exec([false, fn -> {:error, :test_error} end]) ==
        {:error, ":test_error"}
    )
  end

  test "exec/1 boolean 1 input value" do
    [
      {[false], {:ok, true}},
      {[true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nor.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 2 input values" do
    [
      {[false, false], {:ok, true}},
      {[false, true], {:ok, false}},
      {[true, false], {:ok, false}},
      {[true, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nor.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 3 input values" do
    [
      {[false, false, false], {:ok, true}},
      {[false, false, true], {:ok, false}},
      {[false, true, false], {:ok, false}},
      {[false, true, true], {:ok, false}},
      {[true, false, false], {:ok, false}},
      {[true, false, true], {:ok, false}},
      {[true, true, false], {:ok, false}},
      {[true, true, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nor.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 function 1 input value" do
    [
      {[false], {:ok, true}},
      {[true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Nor.exec(
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
      {[false, false], {:ok, true}},
      {[false, true], {:ok, false}},
      {[true, false], {:ok, false}},
      {[true, true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Nor.exec(
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
      {[false, false, false], {:ok, true}},
      {[false, false, true], {:ok, false}},
      {[false, true, false], {:ok, false}},
      {[false, true, true], {:ok, false}},
      {[true, false, false], {:ok, false}},
      {[true, false, true], {:ok, false}},
      {[true, true, false], {:ok, false}},
      {[true, true, true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Nor.exec(
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
      {[false, fn -> {:ok, false} end, false], {:ok, true}},
      {[false, fn -> {:ok, false} end, true], {:ok, false}},
      {[false, fn -> {:ok, true} end, false], {:ok, false}},
      {[false, fn -> {:ok, true} end, true], {:ok, false}},
      {[true, fn -> {:ok, false} end, false], {:ok, false}},
      {[true, fn -> {:ok, false} end, true], {:ok, false}},
      {[true, fn -> {:ok, true} end, false], {:ok, false}},
      {[true, fn -> {:ok, true} end, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nor.exec(input_values) == expected_output)
    end)
  end
end
