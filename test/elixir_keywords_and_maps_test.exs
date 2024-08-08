defmodule KeywordsAndMapsTests do
  use ExUnit.Case

  describe "Keyword lists" do
    test "String.split with trim option" do
      assert String.split("1  2  3", " ", trim: true) == ["1", "2", "3"]
    end

    test "keyword lists as lists of tuples" do
      assert [{:trim, true}] == [trim: true]
    end

    test "adding new values to a keyword list" do
      list = [a: 1, b: 2]
      assert list ++ [c: 3] == [a: 1, b: 2, c: 3]
      assert [a: 0] ++ list == [a: 0, a: 1, b: 2]
    end

    test "reading values from a keyword list" do
      list = [a: 1, b: 2]
      assert list[:a] == 1
      assert list[:b] == 2
    end

    test "duplicate keys in keyword lists" do
      list = [a: 1, b: 2]
      new_list = [a: 0] ++ list
      assert new_list[:a] == 0
    end

    test "pattern match on keyword lists" do
      [a: a] = [a: 1]
      assert a == 1
    end

    # test "pattern match on keyword lists with different number of items" do
    #   assert_raise MatchError, fn ->
    #     [a: _a] = [a: 1, b: 2]
    #   end
    # end

    # test "pattern match on keyword lists with different order of items" do
    #   assert_raise MatchError, fn ->
    #     [b: _b, a: _a] = [a: 1, b: 2]
    #   end
    # end

    test "do-blocks as keyword lists" do
      assert (if true do
        "This will be seen"
      else
        "This won't"
      end) == "This will be seen"

      assert (if true, do: "This will be seen", else: "This won't") == "This will be seen"
    end
  end

  describe "Maps" do
    test "basic map operations" do
      map = %{:a => 1, 2 => :b}
      assert map[:a] == 1
      assert map[2] == :b
      assert map[:c] == nil
    end

    test "pattern matching with maps" do
      assert %{} = %{:a => 1, 2 => :b}
      assert %{:a => a} = %{:a => 1, 2 => :b}
      assert a == 1
      # assert_raise MatchError, fn ->
      #   %{:c => c} = %{:a => 1, 2 => :b}
      # end
    end

    test "Map module functions" do
      assert Map.get(%{:a => 1, 2 => :b}, :a) == 1
      assert Map.put(%{:a => 1, 2 => :b}, :c, 3) == %{2 => :b, :a => 1, :c => 3}
      assert Map.to_list(%{:a => 1, 2 => :b}) == [{2, :b}, {:a, 1}]
    end

    test "maps with predefined keys" do
      map = %{name: "John", age: 23}
      assert map.name == "John"
      # assert_raise KeyError, fn ->
      #   map.agee
      # end
    end

    test "updating maps with predefined keys" do
      map = %{name: "John", age: 23}
      assert %{map | name: "Mary"} == %{name: "Mary", age: 23}
      # assert_raise KeyError, fn ->
      #   %{map | agee: 27}
      # end
    end
  end

  describe "Nested data structures" do
    setup do
      users = [
        john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
        mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
      ]
      {:ok, users: users}
    end

    test "accessing nested data", %{users: users} do
      assert users[:john].age == 27
    end

    test "updating nested data with put_in", %{users: users} do
      updated_users = put_in(users[:john].age, 31)
      assert updated_users[:john].age == 31
    end

    test "updating nested data with update_in", %{users: users} do
      updated_users = update_in(users[:mary].languages, fn languages -> List.delete(languages, "Clojure") end)
      assert updated_users[:mary].languages == ["Elixir", "F#"]
    end
  end
end
