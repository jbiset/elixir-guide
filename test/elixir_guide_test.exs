defmodule ElixirGuideTest do
  use ExUnit.Case
  doctest ElixirGuide

  test "greets the world" do
    assert ElixirGuide.hello() == :world
  end
end
