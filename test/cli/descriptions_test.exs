defmodule Accio.CLI.DescriptionsTest do
  use ExUnit.Case

  import Accio.CLI.Descriptions

  test "returns :generate command's description without help" do
    desc = description({:generate, "command", nil})

    assert desc =~ "Usage:"
    assert !(desc =~ "Help:")

  end

  test "returns :generate command's description with help" do
    desc = description({:generate, "command", "test"})

    assert desc =~ "Usage:"
    assert desc =~ "Help:"
    assert desc =~ "test"
  end

  test "returns :generate description" do
    assert description({:generate}) =~ "Usage:"
  end

  test "returns :config description" do
    assert description({:config}) =~ "Usage:"
  end

  test "returns :parse description" do
    assert description({:parse}) =~ "Usage:"
  end

  test "returns :help description" do
    assert description({:help}) =~ "Usage:"
  end
end
