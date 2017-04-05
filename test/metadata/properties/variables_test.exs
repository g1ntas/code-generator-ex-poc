defmodule Accio.Metadata.Properties.VariablesTest do
  use ExUnit.Case
  
  alias Accio.Metadata.Properties.Variables
  
  test "it should return error, if command is not specified" do
    params = %Variables{definitions: nil}

    assert Variables.validate(params) == {:error, "Argument of Variables property must be of type map"}
  end

  test "it should return tuple with status :ok, if validation succeeds" do
    params = struct(Variables, %{definitions: %{}})

    assert Variables.validate(params) == {:ok, nil}
  end
end
