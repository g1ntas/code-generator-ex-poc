defmodule Accio.GithubGists do
  @moduledoc """
  This module communicates with GitHub and fetches gists
  """

  alias Accio.Storage.Auth

  @github_url Application.get_env(:accio, :github_api_url)

  @doc """
  Fetch gists from the specified user's account
  """
  @spec fetch(%Auth{}, module) :: {:ok, map} | {:error, binary}
  def fetch(%Auth{username: username, token: token}, http_module \\ HTTPoison) do
    gist_list_url(username)
    |> http_module.get([], [hackney: [basic_auth: {username, token}]])
    |> handle_response()
  end

  @spec handle_response({:ok | :error, map}) :: {:ok | :error, any}
  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body |> Poison.decode!()}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

  defp handle_response({:ok, %{status_code: status_code}}) do
    case(status_code) do
      404 -> {:error, "Page not found"}
      500 -> {:error, "Internal server error"}
      _ -> {:error, "Something went wrong (status code: #{status_code})"}
    end
  end

  @spec gist_list_url(binary) :: binary
  defp gist_list_url(username) do
    "#{@github_url}/users/#{username}/gists"
  end
end
