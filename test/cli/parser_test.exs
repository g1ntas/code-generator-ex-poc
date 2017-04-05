defmodule Accio.CLI.ParserTest do
  use ExUnit.Case

  import Accio.CLI.Parser

  # `config` command
  test "parses command: `config username token`" do
    assert parse_args(["config", "username", "token"]) === {:config, "username", "token"}
  end

  test "parses command: `config username`" do
    assert parse_args(["config", "username"]) === {:config}
  end

  test "parses command: `config`" do
    assert parse_args(["config"]) === {:config}
  end

  test "parses command: `config --help`" do
    assert parse_args(["config", "--help"]) === {:config}
  end

  # `parse` command
  test "parses command: `parse`" do
    assert parse_args(["parse"]) === {:parse}
  end

  test "parses command: `parse --username=username --token=token`" do
    assert parse_args(["parse", "--username", "username", "--token", "token"]) === {:parse, "username", "token"}
  end

  test "parses command: `parse --token=token --username=username`" do
    assert parse_args(["parse", "--token", "token", "--username", "username"]) === {:parse, "username", "token"}
  end

  test "parses command: `parse --help`" do
    assert parse_args(["parse", "--help"]) === {:parse_help}
  end

  # `generate` command
  test "parses command `generate command`" do
    assert parse_args(["generate", "command"]) === {:generate, "command", nil}
  end

  test "parses command `generate command --path`" do
    assert parse_args(["generate", "command", "--path=test/file.ex"]) === {:generate, "command", "test/file.ex"}
  end

  test "parses command `generate command --help`" do
    assert parse_args(["generate", "command", "--help"]) === {:generate_help, "command"}
  end

  test "parses command `generate --help`" do
    assert parse_args(["generate", "--help"]) === {:generate_help}
  end

  test "parses command `generate --vars --var1=value1 --var2=value2`" do
    assert parse_args(["generate", "command", "--vars", "--var1=value1", "--var2=value2"]) === {:generate, "command", %{var1: "value1", var2: "value2"}}
  end

  test "parses command `generate --var1=value1 --vars --var2=value2 --path=test/file.ex`" do
    assert parse_args(["generate", "command", "--vars", "--var1=value1", "--var2=value2", "--path=test/file.ex"]) === {:generate, "command", "test/file.ex", %{var1: "value1", var2: "value2"}}
  end

  # default case
  test "if nothing matches, return help" do
    assert parse_args(["test"]) === {:help}
  end
end
