defmodule BasicTypesTest do
  use ExUnit.Case
  doctest Kernel

  test "basic types" do
    assert is_integer(1)
    assert is_integer(0x1F)
    assert is_float(1.0)
    assert is_boolean(true)
    assert is_atom(:atom)
    assert is_binary("elixir")
    assert is_list([1, 2, 3])
    assert is_tuple({1, 2, 3})
  end

  test "basic arithmetic" do
    assert 1 + 2 == 3
    assert 5 * 5 == 25
    assert 10 / 2 == 5.0
  end

  describe "basic arithmetic operators return types" do
    test "Arithmetic addition operator" do
      assert is_integer(1 + 2)
      assert is_float(1.0 + 2.0)
      assert is_float(1 + 2.0)
      assert is_float(1.0 + 2)
    end
    test "Arithmetic subtraction operator" do
      assert is_integer(2 - 1)
      assert is_float(2.0 - 1.0)
      assert is_float(2 - 1.0)
      assert is_float(2.0 - 1)
    end
    test "Arithmetic multiplication operator" do
      assert is_integer(1 * 2)
      assert is_float(1.0 * 2.0)
      assert is_float(1 * 2.0)
      assert is_float(1.0 * 2)
    end
    test "Arithmetic division operator" do
      assert is_float(10 / 2)
    assert is_float(10 / 2.0)
    assert is_float(10.0 / 2)
    end
  end

  test "integer division and remainder" do
    assert div(10, 2) == 5
    assert rem(10, 3) == 1
  end

  test "support binary(0b), octal(0o), and hexadecimal(0x) notations" do
    assert 0b1010 == 10
    assert 0o777 == 511
    assert 0x1F == 31
  end

  test "round and trunc functions" do
    assert round(3.58) == 4
    assert trunc(3.58) == 3
  end

  test "predicate functions" do
    assert is_integer(1)
    refute is_integer(2.0)
    assert is_float(2.0)
    refute is_float(2)
    assert is_number(1)
    assert is_number(2.0)
  end

  test "booleans and nil" do
    assert true == true
    refute true == false
    assert true and true
    assert false or is_boolean(true)
    assert_raise BadBooleanError, fn -> 1 and true end
    assert (false and raise("This error will never be raised")) == false
    assert (true or raise("This error will never be raised")) == true
  end

  test "logical operators" do
    assert 1 || true == 1
    assert false || 11 == 11
    assert (nil && 13) == nil
    # sassert (true && 17) == 17
    assert !true == false
    assert !1 == false
    assert !nil == true
  end

  test "atoms" do
    assert :apple == :apple
    refute :apple == :orange
    assert true == :true
    assert is_atom(false)
    assert is_boolean(:false)
  end

  test "strings" do
    assert "hello " <> "world!" == "hello world!"
    assert "hello #{:world}!" == "hello world!"
    assert "i am #{42} years old!" == "i am 42 years old!"
    assert IO.puts("hello\nworld") == :ok
    assert is_binary("hellö")
    assert byte_size("hellö") == 6
    assert String.length("hellö") == 5
    assert String.upcase("hellö") == "HELLÖ"
  end

  test "comparison operators" do
    assert 1 == 1
    assert 1 != 2
    assert 1 < 2
    assert "foo" == "foo"
    refute "foo" == "bar"
    assert 1 == 1.0
    refute 1 == 2.0
    refute 1 === 1.0
  end
end
