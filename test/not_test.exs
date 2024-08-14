defmodule NotTest do
  use ExUnit.Case
  doctest LogicGates.Not
  alias LogicGates.Not

  test "exec/1 returns error on invalid parameter type" do
    [
      [false],
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
           "The parameter to LogicGates.Not.exec/1 must be either a boolean or a function. Current parameter: #{inspect(invalid_input)}"}
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
           "When a function is passed as a parameter to LogicGates.Not.exec/1, it must return a tuple consisting of either :ok and a boolean, or :error and a string. Returned value: #{inspect(invalid_return_value)}"}
      )
    end)
  end

  test "exec/1 returns an error when an error is returned from a function input value" do
    assert(
      Not.exec(fn -> {:error, "Test error"} end) ==
        {:error, "Test error"}
    )

    assert(
      Not.exec(fn -> {:error, :test_error} end) ==
        {:error, ":test_error"}
    )
  end

  test "exec/1 boolean input value" do
    [
      {false, {:ok, true}},
      {true, {:ok, false}}
    ]
    |> Enum.each(fn {input_value, expected_output} ->
      assert(Not.exec(input_value) == expected_output)
    end)
  end

  test "exec/1 function input value" do
    [
      {false, {:ok, true}},
      {true, {:ok, false}}
    ]
    |> Enum.each(fn {return_value, expected_output} ->
      assert(Not.exec(fn -> {:ok, return_value} end) == expected_output)
    end)
  end
end
