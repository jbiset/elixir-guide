defmodule ListsAndTuplesTest do
  use ExUnit.Case

  describe "Lists" do
    test "create lists with different types of values" do
      assert [1, 2, true, 3] == [1, 2, true, 3]
    end

    test "length of a list" do
      assert length([1, 2, 3]) == 3
    end

    test "concatenating lists" do
      assert [1, 2, 3] ++ [4, 5, 6] == [1, 2, 3, 4, 5, 6]
    end

    test "subtracting lists" do
      assert [1, true, 2, false, 3, true] -- [true, false] == [1, 2, 3, true]
    end

    test "list operators never modify the existing list" do
      new_list = [1, 2, 3]
      _ = new_list -- [3]
      assert new_list == [1, 2, 3]
    end

    test "retrieving head and tail of a list" do
      list = [1, 2, 3]
      assert hd(list) == 1
      assert tl(list) == [2, 3]
    end

    # test "head of an empty list raises error" do
    #  assert_raise ArgumentError, fn -> hd([]) end
    # end

    test "list of printable ASCII numbers as charlist" do
      assert [104, 101, 108, 108, 111] == ~c"hello"
    end
  end

  describe "Tuples" do
    test "create tuples with different types of values" do
      assert {:ok, "hello"} == {:ok, "hello"}
    end

    test "tuple size" do
      assert tuple_size({:ok, "hello"}) == 2
    end

    test "accessing tuple elements by index" do
      tuple = {:ok, "hello"}
      assert elem(tuple, 1) == "hello"
    end

    test "original tuple is not modified" do
      tuple = {:ok, "hello"}
      _ = put_elem(tuple, 1, "world")
      assert tuple == {:ok, "hello"}
    end

    test "putting an element in a tuple" do
      tuple = {:ok, "hello"}
      new_tuple = put_elem(tuple, 1, "world")
      assert new_tuple == {:ok, "world"}
      assert tuple == {:ok, "hello"}
    end
  end

  describe "Lists vs Tuples" do
    test "accessing list length is linear" do
      list = Enum.to_list(1..1_000_000)
      assert length(list) == 1_000_000
    end

    test "accessing tuple size is constant" do
      tuple = {:a, :b, :c, :d}
      assert tuple_size(tuple) == 4
    end

    test "concatenating lists" do
      list = [1, 2, 3]
      assert [0] ++ list == [0, 1, 2, 3]
      assert list ++ [4] == [1, 2, 3, 4]
    end

    test "updating tuples" do
      tuple = {:a, :b, :c, :d}
      new_tuple = put_elem(tuple, 2, :e)
      assert new_tuple == {:a, :b, :e, :d}
      assert tuple == {:a, :b, :c, :d}
    end
  end

  describe "String module" do
    test "String.split/1 returns a list" do
      assert String.split("hello world") == ["hello", "world"]
      assert String.split("hello beautiful world") == ["hello", "beautiful", "world"]
    end

    test "String.split_at/2 returns a tuple" do
      assert String.split_at("hello world", 3) == {"hel", "lo world"}
      assert String.split_at("hello world", -4) == {"hello w", "orld"}
    end
  end

  describe "Tagged tuples" do
    test "File.read/1 returns tagged tuples" do
      assert File.read("test/example_to_read_file.txt") == {:ok, "example content"}
      assert File.read("unknown_file") == {:error, :enoent}
    end
  end
end
