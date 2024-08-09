defmodule EnumerableAndStreamsTest do
  use ExUnit.Case

  test "Enum.map/2 with lists" do
    assert Enum.map([1, 2, 3], fn x -> x * 2 end) == [2, 4, 6]
  end

  test "Enum.map/2 with maps" do
    assert Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end) == [2, 12]
  end

  test "Enum.reduce/3 with ranges" do
    assert Enum.reduce(1..3, 0, &+/2) == 6
  end

  test "Enum.filter/2 with ranges" do
    odd? = fn x -> rem(x, 2) != 0 end
    assert Enum.filter(1..3, odd?) == [1, 3]
  end

  test "Pipeline operations with Enum" do
    odd? = fn x -> rem(x, 2) != 0 end

    result =
      1..100_000
      |> Enum.map(&(&1 * 3))
      |> Enum.filter(odd?)
      |> Enum.sum()

    assert result == 7_500_000_000
  end

  test "Stream.map/2 and Stream.filter/2 with Stream" do
    odd? = fn x -> rem(x, 2) != 0 end

    result =
      1..100_000
      |> Stream.map(&(&1 * 3))
      |> Stream.filter(odd?)
      |> Enum.sum()

    assert result == 7_500_000_000
  end

  test "Stream.cycle/1" do
    stream = Stream.cycle([1, 2, 3])
    assert Enum.take(stream, 10) == [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]
  end

  test "Stream.unfold/2" do
    stream = Stream.unfold("hełło", &String.next_codepoint/1)
    assert Enum.take(stream, 3) == ["h", "e", "ł"]
  end

  test "File.stream!/1" do
    stream = File.stream!("test/example_to_read_file.txt")
    assert Enum.take(stream, 10) == ["example content"]
  end
end
