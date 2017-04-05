defmodule Accio.GeneratorIOTest do
  use ExUnit.Case

  alias Accio.GeneratorIO
  import ExUnit.CaptureIO

  defmodule FileMock do
    def exists?("existing/path"), do: true
    def exists?("not/existing/path"), do: false
  end

  test "it should prompt for file path" do
    assert capture_io([input: "not/existing/path"], fn ->
      assert GeneratorIO.get_path(nil, FileMock) === "not/existing/path"
    end) =~ "Specify the path, where do you want to generate file"
  end

  test "it should ask to replace file, if the specified path already exists" do
    assert capture_io([input: "existing/path\ny"], fn ->
      assert GeneratorIO.get_path(nil, FileMock) === "existing/path"
    end) =~ "File with the same name already exists, do you want to replace it"
  end

  test "it should ask to enter a new path, if user does not agreed to replace file" do
    assert capture_io([input: "existing/path\nn\nnot/existing/path"], fn ->
      assert GeneratorIO.get_path(nil, FileMock) === "not/existing/path"
    end) =~ "File with the same name already exists, do you want to replace it"
  end

  test "it should ask to replace file, if default path specified already exists" do
    assert capture_io([input: "y"], fn ->
      assert GeneratorIO.get_path("existing/path", FileMock) === "existing/path"
    end) =~ "File with the same name already exists, do you want to replace it"
  end

  test "it should ask to enter the value of each variable" do
    variables = %{var1: "", var2: 0}

    output = capture_io([input: "test\n100"], fn ->
      assert GeneratorIO.get_vars(variables, %{}) === [var1: "test", var2: 100]
    end)

    assert output =~ "Enter the value of the \"\e[39mvar1\e[32m\" variable"
    assert output =~ "Enter the value of the \"\e[39mvar1\e[32m\" variable"
  end

  test "it should show error and ask to enter the value again, if the value is invalid" do
    variables = %{var1: 0}

    output = capture_io([input: "test\n100"], fn ->
      assert GeneratorIO.get_vars(variables, %{}) === [var1: 100]
    end)

    assert output =~ "ERROR: Invalid type of the value given (expected: integer)"
    assert output =~ "Enter the value of the \"\e[39mvar1\e[32m\" variable"
  end

  test "it should ask to enter the value of each variable, which is not already defined" do
    variables = %{var1: "", var2: 0}
    defined_vars = %{var2: "100"}

    output = capture_io([input: "test"], fn ->
      assert GeneratorIO.get_vars(variables, defined_vars) === [var1: "test", var2: 100]
    end)

    assert output =~ "Enter the value of the \"\e[39mvar1\e[32m\" variable"
    assert !(output =~ "Enter the value of the \"\e[39mvar2\e[32m\" variable")
  end

  test "it should cast type all defined variables" do
    variables = %{var1: 0}
    defined_vars = %{var1: "100"}

    assert GeneratorIO.get_vars(variables, defined_vars) === [var1: 100]
  end

  test "it should type cast all defined variables, if it's invalid show error and ask to enter its value" do
    variables = %{var1: %{}}
    defined_vars = %{var1: "[]"}

    output = capture_io([input: "{}"], fn ->
      assert GeneratorIO.get_vars(variables, defined_vars) === [var1: %{}]
    end)

    assert output =~ "ERROR: Invalid type of the value given (expected: map)"
    assert output =~ "Enter the value of the \"\e[39mvar1\e[32m\" variable"
  end
end
