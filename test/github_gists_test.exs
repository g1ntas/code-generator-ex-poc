defmodule Accio.GithubGistsTest do
  use ExUnit.Case

  alias Accio.GithubGists
  alias Accio.Storage.Auth

  test "it should return response body, if request is successful" do
    defmodule HTTPoisonSuccessMock do
      def get("https://api.github.com/users/name/gists", [], [hackney: [basic_auth: {"name", "123"}]]) do
        {:ok, %{status_code: 200, body: "{\"test\":\"test\"}"}}
      end
    end

    auth = %Auth{token: "123", username: "name"}

    assert GithubGists.fetch(auth, HTTPoisonSuccessMock) === {:ok, %{"test" => "test"}}
  end

  test "it should return not found error, if response status is 404" do
    defmodule HTTPoison404ErrorMock do
      def get("https://api.github.com/users/name/gists", [], [hackney: [basic_auth: {"name", "123"}]]) do
        {:ok, %{status_code: 404}}
      end
    end

    auth = %Auth{token: "123", username: "name"}

    assert GithubGists.fetch(auth, HTTPoison404ErrorMock) === {:error, "Page not found"}
  end

  test "it should return internal server error, if response status is 500" do
    defmodule HTTPoison500ErrorMock do
      def get("https://api.github.com/users/name/gists", [], [hackney: [basic_auth: {"name", "123"}]]) do
        {:ok, %{status_code: 500}}
      end
    end

    auth = %Auth{token: "123", username: "name"}

    assert GithubGists.fetch(auth, HTTPoison500ErrorMock) === {:error, "Internal server error"}
  end

  test "it should return error message with status code, if request has failed" do
    defmodule HTTPoisonStatusCodeErrorMock do
      def get("https://api.github.com/users/name/gists", [], [hackney: [basic_auth: {"name", "123"}]]) do
        {:ok, %{status_code: 403}}
      end
    end

    auth = %Auth{token: "123", username: "name"}

    assert GithubGists.fetch(auth, HTTPoisonStatusCodeErrorMock) === {:error, "Something went wrong (status code: 403)"}
  end

  test "it should return error message from API, if request has failed" do
    defmodule HTTPoisonErrorMock do
      def get("https://api.github.com/users/name/gists", [], [hackney: [basic_auth: {"name", "123"}]]) do
        {:error, %{reason: "Request has failed"}}
      end
    end

    auth = %Auth{token: "123", username: "name"}

    assert GithubGists.fetch(auth, HTTPoisonErrorMock) === {:error, "Request has failed"}
  end
end
