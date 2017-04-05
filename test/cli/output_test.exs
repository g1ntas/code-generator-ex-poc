defmodule Accio.CLI.OutputTest do
  use ExUnit.Case
  doctest Accio.CLI.Output
  
  import Accio.CLI.Output
  import ExUnit.CaptureIO

  test "formats ANSI styles" do
    assert format("~g~green") == [IO.ANSI.green(), "green"]
    assert format("~r~red") == [IO.ANSI.red(), "red"]
    assert format("~d~default color") == [IO.ANSI.default_color(), "default color"]
    assert format("~y~default color") == [IO.ANSI.yellow(), "default color"]
  end

  test "prints error text of red color" do
    assert capture_io(fn -> error("TEST") end)  == "\e[31mTEST\e[39m\n"
  end

  test "prints text of green color" do
    assert capture_io(fn -> puts("TEST") end) == "\e[32mTEST\e[39m\n"
  end
end
