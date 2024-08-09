defmodule AnonymousFunctionsTest do
  use ExUnit.Case

  test "defining and invoking anonymous functions" do
    add = fn a, b -> a + b end
    assert add.(1, 2) == 3
    assert is_function(add)
    assert is_function(add, 2)
    refute is_function(add, 1)
  end

  test "closures in anonymous functions" do
    add = fn a, b -> a + b end
    double = fn a -> add.(a, a) end
    assert double.(2) == 4

    x = 42
    # assert (fn -> x = 0 end).() == 0
    assert x == 42
  end

  test "anonymous functions with clauses and guards" do
    addOrMultiply = fn
      x, y when x > 0 -> x + y
      x, y -> x * y
    end

    assert addOrMultiply.(1, 3) == 4
    assert addOrMultiply.(-1, 3) == -3

    # assert_raise CompileError, fn ->
    #   f2 = fn
    #     x, y when x > 0 -> x + y
    #     x, y, z -> x * y + z
    #   end
    # end
  end

  test "capturing functions with the capture operator" do
    fun = &is_atom/1
    assert is_function(fun)
    assert fun.(:hello)
    refute fun.(123)

    fun = &String.length/1
    assert fun.("hello") == 5

    add = &+/2
    assert add.(1, 2) == 3

    fun = &(&1 + 1)
    assert fun.(1) == 2

    fun2 = &"Good #{&1}"
    assert fun2.("morning") == "Good morning"
  end
end
