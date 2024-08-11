defmodule NotTest do
  use ExUnit.Case
  doctest LogicGates.Not
  alias LogicGates.Not

  test "exec/1 returns error on invalid parameter type" do
    [
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_input ->
      assert(
        Not.exec(invalid_input) ==
          {:error,
           "Error in LogicGates.Not.exec/1: The parameter to the function must be either a boolean, a function or a list with exactly one element. Current parameter: #{inspect(invalid_input)}"}
      )
    end)
  end

  test "exec/1 returns an error on empty list input" do
    assert(
      Not.exec([]) ==
        {:error, "Error in LogicGates.Not.exec/1: An NOT gate requires exactly one input value."}
    )
  end

  test "exec/1 returns an error on list input with two elements" do
    assert(
      Not.exec([]) ==
        {:error, "Error in LogicGates.Not.exec/1: An NOT gate requires exactly one input value."}
    )
  end

  test "exec/1 returns error on invalid type of element within list" do
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
        Not.exec([invalid_value]) ==
          {:error,
           "Error in LogicGates.Not.exec/1: If a list is passed as a parameter, its single element must be either a boolean or a function. Current element: #{inspect(invalid_value)}"}
      )
    end)
  end

  test "exec/1 returns error on invalid return type of function value" do
    [
      "false",
      %{true: false},
      {true, false},
      0,
      1.0,
      nil
    ]
    |> Enum.each(fn invalid_return_value ->
      assert(
        Not.exec(fn -> invalid_return_value end) ==
          {:error,
           "Error in LogicGates.Not.exec/1: When a function is passed as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )

      assert(
        Not.exec([fn -> invalid_return_value end]) ==
          {:error,
           "Error in LogicGates.Not.exec/1: When a function is passed as an input value, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is return from a function input value" do
    assert(
      Not.exec(fn -> {:error, "Test error"} end) ==
        {:error,
         "Error in LogicGates.Not.exec/1: An error was returned by a function input value: \"Test error\""}
    )

    assert(
      Not.exec([fn -> {:error, "Test error"} end]) ==
        {:error,
         "Error in LogicGates.Not.exec/1: An error was returned by a function input value: \"Test error\""}
    )
  end

  test "exec/1 boolean input value" do
    [
      {false, {:ok, true}},
      {true, {:ok, false}}
    ]
    |> Enum.each(fn {input_value, expected_output} ->
      assert(Not.exec(input_value) == expected_output)
      assert(Not.exec([input_value]) == expected_output)
    end)
  end

  test "exec/1 function input value" do
    [
      {false, {:ok, true}},
      {true, {:ok, false}}
    ]
    |> Enum.each(fn {return_value, expected_output} ->
      assert(Not.exec(fn -> {:ok, return_value} end) == expected_output)
      assert(Not.exec([fn -> {:ok, return_value} end]) == expected_output)
    end)
  end
end
