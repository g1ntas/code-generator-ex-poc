defmodule Accio.Storage.DETSTest do
  use ExUnit.Case

  alias Accio.Storage.DETS

  test "it should insert data into the storage file" do
    defmodule DETSInsertMock do
      def insert(:table, {:key, "data"}), do: :ok
    end

    assert DETS.insert(:table, :key, "data", DETSInsertMock) === :ok
  end

  test "it should read data from the storage file" do
    defmodule DETSReadMock do
      def lookup(:table, :key), do: [{:key, "data"}]
    end

    assert DETS.read(:table, :key, DETSReadMock) === {:ok, "data"}
  end

  test "it should return error if fetched data is empty" do
    defmodule DETSReadErrorMock do
      def lookup(:table, :key), do: []
    end

    assert DETS.read(:table, :key, DETSReadErrorMock) === {:error, :empty}
  end

  test "it should return error given by lookup function" do
    defmodule DETSReadError2Mock do
      def lookup(:table, :key), do: {:error, "test"}
    end

    assert DETS.read(:table, :key, DETSReadError2Mock) === {:error, "test"}
  end

  test "it should open storage file" do
    defmodule DETSOpenMock do
      def open_file(:table, [type: :set, file: :"test/table"]), do: {:ok, :table}
    end

    assert DETS.open_file(:table, DETSOpenMock) === {:ok, :table}
  end

  test "it should close storage file" do
    defmodule DETSCloseMock do
      def close(:table), do: :ok
    end

    assert DETS.close_file(:table, DETSCloseMock) === :ok
  end
end
