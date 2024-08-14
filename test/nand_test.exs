defmodule NandTest do
  use ExUnit.Case
  doctest LogicGates.Nand
  alias LogicGates.Nand

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
        Nand.exec(invalid_input) ==
          {:error,
           "The parameter to LogicGates.Nand.exec/1 must be a list. Current parameter: #{inspect(invalid_input)}"}
      )
    end)
  end

  test "exec/1 returns an error on empty list input" do
    assert(
      Nand.exec([]) ==
        {:error,
         "LogicGates.Nand.exec/1 requires the input list to contain at least one element."}
    )
  end

  test "exec/1 returns error on invalid type of input value" do
    [
      [false],
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_value ->
      assert(
        Nand.exec([true, invalid_value]) ==
          {:error,
           "Each element in the input list for LogicGates.Nand.exec/1 must be either a function or a boolean. Current value: #{inspect(invalid_value)}"}
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
        Nand.exec([fn -> invalid_return_value end]) ==
          {:error,
           "When a function is passed to LogicGates.Nand.exec/1 as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is returned from a function input value" do
    assert(
      Nand.exec([false, fn -> {:error, "Test error"} end]) ==
        {:error, "Test error"}
    )

    assert(
      Nand.exec([false, fn -> {:error, :test_error} end]) ==
        {:error, ":test_error"}
    )
  end

  test "exec/1 boolean 1 input value" do
    [
      {[false], {:ok, true}},
      {[true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nand.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 2 input values" do
    [
      {[false, false], {:ok, true}},
      {[false, true], {:ok, true}},
      {[true, false], {:ok, true}},
      {[true, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nand.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 boolean 3 input values" do
    [
      {[false, false, false], {:ok, true}},
      {[false, false, true], {:ok, true}},
      {[false, true, false], {:ok, true}},
      {[false, true, true], {:ok, true}},
      {[true, false, false], {:ok, true}},
      {[true, false, true], {:ok, true}},
      {[true, true, false], {:ok, true}},
      {[true, true, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nand.exec(input_values) == expected_output)
    end)
  end

  test "exec/1 function 1 input value" do
    [
      {[false], {:ok, true}},
      {[true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Nand.exec(
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
      {[false, true], {:ok, true}},
      {[true, false], {:ok, true}},
      {[true, true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Nand.exec(
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
      {[false, false, true], {:ok, true}},
      {[false, true, false], {:ok, true}},
      {[false, true, true], {:ok, true}},
      {[true, false, false], {:ok, true}},
      {[true, false, true], {:ok, true}},
      {[true, true, false], {:ok, true}},
      {[true, true, true], {:ok, false}}
    ]
    |> Enum.each(fn {return_values, expected_output} ->
      assert(
        Nand.exec(
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
      {[false, fn -> {:ok, false} end, true], {:ok, true}},
      {[false, fn -> {:ok, true} end, false], {:ok, true}},
      {[false, fn -> {:ok, true} end, true], {:ok, true}},
      {[true, fn -> {:ok, false} end, false], {:ok, true}},
      {[true, fn -> {:ok, false} end, true], {:ok, true}},
      {[true, fn -> {:ok, true} end, false], {:ok, true}},
      {[true, fn -> {:ok, true} end, true], {:ok, false}}
    ]
    |> Enum.each(fn {input_values, expected_output} ->
      assert(Nand.exec(input_values) == expected_output)
    end)
  end
end
