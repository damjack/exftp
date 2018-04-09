defmodule ExftpTest do
  use ExUnit.Case
  doctest Exftp

  test "greets the world" do
    assert Exftp.hello() == :world
  end
end
