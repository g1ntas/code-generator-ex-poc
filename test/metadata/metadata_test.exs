defmodule Accio.Metadata.MetadataTest do
  use ExUnit.Case

  alias Accio.Metadata.Metadata
  alias Accio.Metadata.Properties.Command

  test "parses AST list" do
    ast = [
      {:command, ["command", {:description, "text"}]}
    ]

    assert Metadata.parse(ast) == {:ok, %Metadata{command: %Command{command: "command", description: "text"}}}
  end

  test "returns error, if property is unknown" do
    ast = [
      {:unknown, ["param"]}
    ]

    assert Metadata.parse(ast) == {:error, "Unknown property \"unknown\""}
  end

  test "it should return description of the command" do
    metadata = %Metadata{command: %Command{description: "test"}}

    assert Metadata.get(metadata, :command, :description) === "test"
  end

  test "it should return nil, if no prefered properties are set" do
    metadata = %Metadata{}

    assert Metadata.get(metadata, :variables, :definitions) === nil
  end
end
