defmodule CaseCondAndIfTest do
  use ExUnit.Case

  describe "case" do
    test "matching tuple with case" do
      result = case {1, 2, 3} do
        {4, 5, 6} ->
          "This clause won't match"
        {1, _x, 3} ->
          "This clause will match and bind _x to 2 in this clause"
        _ ->
          "This clause would match any value"
      end
      assert result == "This clause will match and bind _x to 2 in this clause"
    end

    # test "pattern match against an existing variable" do
    #   x = 1
    #   result = case 10 do
    #     ^x -> "Won't match"
    #     _ -> "Will match"
    #   end
    #   assert result == "Will match"
    # end

    test "case with guard clause" do
      result = case {1, 2, 3} do
        {1, x, 3} when x > 0 ->
          "Will match"
        _ ->
          "Would match, if guard condition were not satisfied"
      end
      assert result == "Will match"
    end

    test "errors in guards do not leak" do
      result = case 1 do
        x when hd(x) -> "Won't match"
        x -> "Got #{x}"
      end
      assert result == "Got 1"
    end

    # test "no matching case clause raises an error" do
    #   assert_raise CaseClauseError, fn ->
    #     case :ok do
    #       :error -> "Won't match"
    #     end
    #   end
    # end
  end

  describe "if/unless" do
    test "if true condition" do
      result = if true do
        "This works!"
      end
      assert result == "This works!"
    end

    test "unless true condition" do
      result = unless true do
        "This will never be seen"
      end
      assert result == nil
    end

    test "if else condition" do
      result = if nil do
        "This won't be seen"
      else
        "This will"
      end
      assert result == "This will"
    end

    # test "variable scoping in if" do
    #   x = 1
    #   if true do
    #     x = x + 1
    #   end
    #   assert x == 1
    # end

    test "return value from if to change value" do
      x = 1
      x = if true do
        x + 1
      else
        x
      end
      assert x == 2
    end
  end

  describe "cond" do
    test "matching multiple conditions with cond" do
      result = cond do
        2 + 2 == 5 ->
          "This will not be true"
        2 * 2 == 3 ->
          "Nor this"
        1 + 1 == 2 ->
          "But this will"
      end
      assert result == "But this will"
    end

    test "cond with final true condition" do
      result = cond do
        2 + 2 == 5 ->
          "This is never true"
        2 * 2 == 3 ->
          "Nor this"
        true ->
          "This is always true (equivalent to else)"
      end
      assert result == "This is always true (equivalent to else)"
    end

    test "cond considers non-nil and non-false as true" do
      result = cond do
        hd([1, 2, 3]) ->
          "1 is considered as true"
      end
      assert result == "1 is considered as true"
    end
  end
end
