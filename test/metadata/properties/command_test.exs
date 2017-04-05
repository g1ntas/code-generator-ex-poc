defmodule Accio.Metadata.Properties.CommandTest do
  use ExUnit.Case
  
  alias Accio.Metadata.Properties.Command
  
  test "it should return error, if command is not specified" do
    params = struct(Command, %{command: nil})

    assert Command.validate(params) == {:error, "Command must be specified"}
  end

  test "it should return error, if command is not type of string" do
    params = struct(Command, %{command: 50})

    assert Command.validate(params) == {:error, "Command must be a string"}
  end

  test "it should return error, if command starts or ends with a dash" do
    params1 = struct(Command, %{command: "-test"})
    params2 = struct(Command, %{command: "test-"})
    error = {:error, "Command can only contain alphabetical symbols, digits, dashes, colons and underscores, and can't start or end with a dash or a colon"}

    assert Command.validate(params1) == error
    assert Command.validate(params2) == error
  end

  test "it should return tuple with status :ok, if validation succeeds" do
    params = struct(Command, %{command: "_Te:st-9"})

    assert Command.validate(params) == {:ok, nil}
  end

  test "it should return error, if description is not nil and is not string" do
    params = struct(Command, %{command: "test", description: 100})

    assert Command.validate(params) == {:error, "Description must be a string"}
  end
end
