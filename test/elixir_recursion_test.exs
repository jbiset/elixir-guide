defmodule RecursionTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  defmodule Recursion do
    def print_multiple_times(msg, n) when n > 0 do
      IO.puts(msg)
      print_multiple_times(msg, n - 1)
    end

    def print_multiple_times(_msg, 0) do
      :ok
    end
  end

  defmodule Math do
    def sum_list([head | tail], accumulator) do
      sum_list(tail, head + accumulator)
    end

    def sum_list([], accumulator) do
      accumulator
    end

    def double_each([head | tail]) do
      [head * 2 | double_each(tail)]
    end

    def double_each([]) do
      []
    end
  end

  test "Recursion.print_multiple_times/2 prints the message n times" do
    assert capture_io(fn -> Recursion.print_multiple_times("Hello!", 3) end) ==
             "Hello!\nHello!\nHello!\n"
  end

  test "Recursion.print_multiple_times/2 returns :ok when n is 0" do
    assert Recursion.print_multiple_times("Hello!", 0) == :ok
  end

  test "Recursion.print_multiple_times/2 raises a FunctionClauseError when n is negative" do
    assert_raise FunctionClauseError, fn -> Recursion.print_multiple_times("Hello!", -1) end
  end

  test "Math.sum_list/2 returns the sum of a list of numbers" do
    assert Math.sum_list([1, 2, 3], 0) == 6
    assert Math.sum_list([], 0) == 0
  end

  test "Math.double_each/1 doubles each element in the list" do
    assert Math.double_each([1, 2, 3]) == [2, 4, 6]
    assert Math.double_each([]) == []
  end
end
