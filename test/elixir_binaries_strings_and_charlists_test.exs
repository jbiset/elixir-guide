defmodule BinariesStringsCharlistsTest do
  use ExUnit.Case

  describe "Binaries, strings, and charlists" do
    test "check if a string is a binary" do
      string = "hello"
      assert is_binary(string)
    end

    test "unicode and code points" do
      assert ?a == 97
      assert ?ł == 322
      assert "\u0061" == "a"
    end

    test "utf-8 encoding and byte size" do
      string = "héllo"
      assert String.length(string) == 5
      assert byte_size(string) == 6
    end

    test "string graphemes and code points" do
      assert String.codepoints("👩‍🚒") == ["👩", "‍", "🚒"]
      assert String.graphemes("👩‍🚒") == ["👩‍🚒"]
      assert String.length("👩‍🚒") == 1
    end

    test "viewing string's binary representation" do
      assert "hełło" <> <<0>> == <<104, 101, 197, 130, 197, 130, 111, 0>>
      assert IO.inspect("hełło", binaries: :as_binaries) == <<104, 101, 197, 130, 197, 130, 111>>
    end

    test "bitstrings" do
      assert <<42>> == <<42::8>>
      assert <<3::4>> == <<3::size(4)>>
      assert <<0::1, 0::1, 1::1, 1::1>> == <<3::4>>
      assert <<1>> == <<257>>
    end

    test "binaries" do
      assert is_bitstring(<<3::4>>)
      assert not is_binary(<<3::4>>)
      assert is_binary(<<0, 255, 42>>)
      assert is_binary(<<42::16>>)
    end

    test "pattern matching on binaries" do
      assert <<0, 1, x>> = <<0, 1, 2>>
      assert x == 2

      assert_raise MatchError, fn ->
        <<0, 1, _x>> = <<0, 1, 2, 3>>
      end

      assert <<0, 1, x::binary>> = <<0, 1, 2, 3>>
      assert x == <<2, 3>>

      assert <<head::binary-size(2), rest::binary>> = <<0, 1, 2, 3>>
      assert head == <<0, 1>>
      assert rest == <<2, 3>>
    end

    test "validating binaries and strings" do
      assert is_binary("hello")
      assert is_binary(<<239, 191, 19>>)
      assert not String.valid?(<<239, 191, 19>>)
    end

    test "concatenating binaries and strings" do
      assert "a" <> "ha" == "aha"
      assert <<0, 1>> <> <<2, 3>> == <<0, 1, 2, 3>>
    end

    test "pattern matching on strings" do
      assert <<head, rest::binary>> = "banana"
      assert head == ?b
      assert rest == "anana"

      assert "ü" <> <<0>> == <<195, 188, 0>>
      assert <<x, rest::binary>> = "über"
      assert x != ?ü
      assert rest == <<188, 98, 101, 114>>

      assert <<x::utf8, rest::binary>> = "über"
      assert x == ?ü
      assert rest == "ber"
    end

    test "charlists" do
      assert ~c"hello" == [?h, ?e, ?l, ?l, ?o]
      assert ~c"hełło" == [104, 101, 322, 322, 111]
      assert is_list(~c"hełło")

      heartbeats_per_minute = [99, 97, 116]
      assert inspect(heartbeats_per_minute, charlists: :as_list) == "[99, 97, 116]"

      assert to_charlist("hełło") == [104, 101, 322, 322, 111]
      assert to_string(~c"hełło") == "hełło"
      assert to_string(:hello) == "hello"
      assert to_string(1) == "1"
    end

    test "concatenating charlists" do
      assert ~c"this " ++ ~c"works" == ~c"this works"
      # assert_raise ArgumentError, fn ->
      #   "he" ++ "llo"
      # end
      assert "he" <> "llo" == "hello"
    end
  end
end
