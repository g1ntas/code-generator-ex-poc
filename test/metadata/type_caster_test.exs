defmodule Accio.Metadata.TypeCasterTest do
  use ExUnit.Case

  import Accio.Metadata.TypeCaster

  test "cast integer" do
    assert cast("5", 0) === {:ok, 5}
  end

  test "cast float" do
    assert cast("5.5", 1.0) === {:ok, 5.5}
  end

  test "cast string" do
    assert cast("test", "") === {:ok, "test"}
  end

  test "cast boolean" do
    assert cast("true", false) === {:ok, true}
  end

  test "cast map" do
    assert cast("{key: \"value\"}", %{}) === {:ok, %{key: "value"}}
  end

  test "cast map with each of other type" do
    input = """
    {
      integer: 5,
      string: \"test\",
      float: 5.5,
      map: {key: \"value\"},
      list: [1, 2]
    }
    """

    assert cast(input, %{}) === {:ok,
      %{
        integer: 5,
        float: 5.5,
        string: "test",
        map: %{key: "value"},
        list: [1, 2]
      }
    }
  end

  test "cast list" do
    assert cast("[1, 2, 3]", []) === {:ok, [1, 2, 3]}
  end

  test "cast list with each of other type" do
    assert cast("[1, \"2\", 3.0, [1], {key: 2}]", []) === {:ok, [1, "2", 3.0, [1], %{key: 2}]}
  end

  test "it should return error if integer input is invalid" do
    assert cast("invalid", 0) === {:error, "Invalid type of the value given (expected: integer)"}
  end

  test "it should return error if float input is invalid" do
    assert cast("invalid", 0.1) === {:error, "Invalid type of the value given (expected: float)"}
  end

  test "it should return error if boolean input is invalid" do
    assert cast("invalid", false) === {:error, "Invalid type of the value given (expected: boolean)"}
  end

  test "it should return error if map input is invalid" do
    assert cast("[]", %{}) === {:error, "Invalid type of the value given (expected: map)"}
  end

  test "it should return error if list input is invalid" do
    assert cast("{}", []) === {:error, "Invalid type of the value given (expected: list)"}
  end
end
