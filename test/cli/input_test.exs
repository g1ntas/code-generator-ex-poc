defmodule Accio.CLI.InputTest do
  use ExUnit.Case

  import Accio.CLI.Input
  import ExUnit.CaptureIO

  test "Simple prompt" do
    assert capture_io([input: "test"], fn -> read("Question") end) == "\e[32mQuestion: \e[39m"
  end

  test "Required prompt" do
    assert capture_io([input: "test"], fn -> read_required("Question", nil) end) == "\e[32mQuestion: \e[39m"
    assert capture_io([input: "\ntest", capture_prompt: false], fn -> read_required("Question", nil) end) == "\e[31mValue is required\e[39m\n"
  end

  test "Confirm prompt" do
    assert capture_io([input: " "], fn -> confirm("Question", true) end) == "\e[32mQuestion [\e[39mY/n\e[32m]? \e[39m"
    assert capture_io([input: "y"], fn -> confirm("Question", true) end) == "\e[32mQuestion [\e[39mY/n\e[32m]? \e[39m"
    assert capture_io([input: "n"], fn -> confirm("Question", false) end) == "\e[32mQuestion [\e[39my/N\e[32m]? \e[39m"
    assert capture_io([input: "test\nn", capture_prompt: false], fn -> confirm("Question", false) end) == "\e[31mInvalid value\e[39m\n"
  end

  test "it should show the default map value as a string" do
    default_value = %{string: "value", integer: 5, float: 5.5, map: %{key: "value"}, empty: %{}}
    expected_string = "{empty: {}, float: 5.5, integer: 5, map: {key: \"value\"}, string: \"value\"}"

    assert capture_io([input: "test"], fn -> read("Question", default_value) end) =~ expected_string
  end

  test "it should show the default list value as a string" do
    default_value = [1, "2", 3.0, [1], []]
    expected_string = "[1, \"2\", 3.0, [1], []]"

    assert capture_io([input: "test"], fn -> read("Question", default_value) end) =~ expected_string
  end
end
