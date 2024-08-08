defmodule ModulesAndFunctionsTest do
  use ExUnit.Case

  defmodule Math do
    def sum(a, b) do
      a + b
    end

    def make_sum(a, b) do
      do_sum(a, b)
    end

    defp do_sum(a, b) do
      a + b
    end

    def zero?(0), do: true
    def zero?(x) when is_integer(x), do: false
  end

  defmodule Concat do
    def join(a, b, sep \\ " ") do
      a <> sep <> b
    end
  end

  defmodule ConcatWithDefault do
    def join(a, b \\ nil, sep \\ " ")

    def join(a, b, _sep) when is_nil(b) do
      a
    end

    def join(a, b, sep) do
      a <> sep <> b
    end
  end

  test "Math.sum/2 returns the sum of two numbers" do
    assert Math.sum(1, 2) == 3
    assert Math.sum(-1, 1) == 0
    assert Math.sum(0, 0) == 0
  end

    test "Math.zero?/1 returns true if the number is zero" do
    assert Math.zero?(0) == true
  end

  test "Math.zero?/1 returns false if the number is non-zero" do
    assert Math.zero?(1) == false
    assert Math.zero?(-1) == false
  end

  test "Math.zero?/1 raises an error for non-integer inputs" do
    assert_raise FunctionClauseError, fn -> Math.zero?([1, 2, 3]) end
    assert_raise FunctionClauseError, fn -> Math.zero?(0.0) end
  end

  test "Math.make_sum/2 returns the sum of two numbers like Math.sum/2" do
    assert Math.sum(1, 2) == 3
    assert Math.sum(-1, 1) == 0
    assert Math.sum(0, 0) == 0
  end

  test "Math.do_sum/2 cannot be called outside of the Math module" do
    assert_raise UndefinedFunctionError, fn  -> Math.do_sum(1, 2) end
  end

  test "Concat.join/2 concatenates two strings with default separator" do
    assert Concat.join("Hello", "world") == "Hello world"
  end

  test "Concat.join/3 concatenates two strings with given separator" do
    assert Concat.join("Hello", "world", "_") == "Hello_world"
  end

  test "Concat.join/3 returns the first string if the second string is nil" do
    assert ConcatWithDefault.join("Hello") == "Hello"
  end
end
