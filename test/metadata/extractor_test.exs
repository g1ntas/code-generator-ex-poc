defmodule Accio.Metadata.ExtractorTest do
  use ExUnit.Case
  
  import Accio.Metadata.Extractor

  test "extracts properties without params" do
    body = """
    <%#
      @property()
      @property_2
    %>
    """

    assert extract(body) == {:ok, [
      {:property, []},
      {:property_2, []},
    ]}
  end

  test "extracts string" do
    body = """
    <%#
      @property("it's a test string")
    %>
    """

    assert extract(body) == {:ok, [{:property, ["it's a test string"]}]}
  end

  test "extracts string with escaped quote character" do
    body = """
    <%#
      @property("\\"it's a test string with escaped quote characters\\"")
    %>
    """

    assert extract(body) == {:ok, [{:property, ["\\\"it's a test string with escaped quote characters\\\""]}]}
  end

  test "extracts integer" do
    body = """
    <%#
      @property(999999)
    %>
    """

    assert extract(body) == {:ok, [{:property, [999999]}]}
  end

  test "extracts float" do
    body = """
    <%#
      @property(20.00)
    %>
    """

    assert extract(body) == {:ok, [{:property, [20.0]}]}
  end

  test "extracts boolean" do
    body = """
    <%#
      @property(true)
      @property2(false)
    %>
    """

    assert extract(body) == {:ok, [
      {:property, [true]},
      {:property2, [false]},
    ]}
  end

  test "extracts list" do
    body = """
    <%#
      @property([1, 2, 3, 4, 5])
    %>
    """

    assert extract(body) == {:ok, [{:property, [[1, 2, 3, 4, 5]]}]}
  end

  test "extracts nested list" do
    body = """
    <%#
      @property([1, [1, 2, [1]], 2, []])
    %>
    """

    assert extract(body) == {:ok, [{:property, [[1, [1, 2, [1]], 2, []]]}]}
  end

  test "extracts map" do
    body = """
    <%#
      @property({a: 1, b: 2, c: 3})
    %>
    """

    assert extract(body) == {:ok, [{:property, [%{a: 1, b: 2, c: 3}]}]}
  end

  test "extracts nested map" do
    body = """
    <%#
      @property({a: {a: 1, b: {a: 2}}, c: {}})
    %>
    """

    assert extract(body) == {:ok, [{:property, [%{
      a: %{
        a: 1,
        b: %{a: 2}
      }, 
      c: %{}
    }]}]}
  end

  test "extracts property with named params" do
    body = """
    <%#
      @property("test", name="test", test=2)
    %>
    """

    assert extract(body) == {:ok, [{:property, [
      "test",
      {:name, "test"},
      {:test, 2}
    ]}]}
  end

  test "returns error, if metadata definition wasn't found" do
    assert extract("") == {:error, :no_metadata}
  end

  test "extracts metadata, if it contains closing tag as string" do
    body = """
    <%#
      @property("%>")
    %>
    """

    assert extract(body) == {:ok, [{:property, ["%>"]}]}
  end

  test "returns error, if file's body contains any character before metadata definition" do
    body = """
    test
    <%#
      @property("test")
    %>
    """

    assert extract(body) == {:error, :no_metadata}
  end
end
