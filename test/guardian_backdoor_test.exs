defmodule Guardian.BackdoorTest do
  use ExUnit.Case
  doctest Guardian.Backdoor

  test "greets the world" do
    assert Guardian.Backdoor.hello() == :world
  end
end
