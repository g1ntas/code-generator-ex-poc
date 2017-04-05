defmodule Accio.Storage.AuthTest do
  use ExUnit.Case

  alias Accio.Storage.Auth
  import ExUnit.CaptureIO

  test "it should save credentials into the storage" do
    defmodule StorageSaveMock do
      def open_file(:auth), do: :ok
      def insert(:auth, :auth, %Auth{username: "John", token: "test"}), do: :ok
      def close_file(:auth), do: :ok
    end

    data = %Auth{token: "test", username: "John"}

    assert Auth.save(data, StorageSaveMock) === :ok
  end

  test "it should read credentials from the storage" do
    defmodule StorageReadMock do
      def open_file(:auth), do: :ok
      def read(:auth, :auth), do: {:ok, %Auth{username: "John", token: "test"}}
      def close_file(:auth), do: :ok
    end

    assert Auth.get_credentials(StorageReadMock) === %Auth{token: "test", username: "John"}
  end

  test "it should show error, when data was not found" do
    defmodule StorageReadErrorMock do
      def open_file(:auth), do: :ok
      def read(:auth, :auth), do: {:error, :empty}
      def close_file(:auth), do: :ok
    end

    output = capture_io(fn ->
      try do
        Auth.get_credentials(StorageReadErrorMock)
      catch
        :exit, :shutdown -> ""
      end
    end)

    assert output =~ "There was an error"
  end
end
