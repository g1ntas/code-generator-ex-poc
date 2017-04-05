defmodule Accio.Storage.GistTest do
  use ExUnit.Case

  alias Accio.Storage.Gist
  import ExUnit.CaptureIO

  test "it should save gist into the storage" do
    defmodule StorageSaveMock do
      def open_file(:gists), do: :ok
      def insert(:gists, "test", %Gist{key: "test", metadata: %{}, template: "..."}), do: :ok
      def close_file(:gists), do: :ok
    end

    data = [%Gist{key: "test", metadata: %{}, template: "..."}]

    assert Gist.save(data, StorageSaveMock) === :ok
  end

  test "it should get gist by specified key/command" do
    defmodule StorageReadMock do
      def open_file(:gists), do: :ok
      def read(:gists, "test"), do: {:ok, %Gist{key: "test", metadata: %{}, template: "..."}}
      def close_file(:gists), do: :ok
    end

    assert Gist.get("test", StorageReadMock) === %Gist{key: "test", metadata: %{}, template: "..."}
  end

  test "it should show error, when data was not found" do
    defmodule StorageReadErrorMock do
      def open_file(:gists), do: :ok
      def read(:gists, "test"), do: {:error, :empty}
      def close_file(:gists), do: :ok
    end

    output = capture_io(fn ->
      try do
        Gist.get("test", StorageReadErrorMock)
      catch
        :exit, :shutdown -> ""
      end
    end)

    assert output =~ "\e[31mERROR: \e[39mcommand not found\e[39m\n"
  end
end
