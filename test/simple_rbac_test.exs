defmodule SimpleRbacTest do
  use ExUnit.Case
  doctest SimpleRbac

  test "greets the world" do
    assert SimpleRbac.hello() == :world
  end
end
