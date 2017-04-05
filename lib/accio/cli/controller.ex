defmodule Accio.CLI.Controller do
  @moduledoc """
  Controls command behaviours.
  """

  alias Accio.CLI.Descriptions
  alias Accio.CLI.Output
  alias Accio.GithubGists
  alias Accio.Generator
  alias Accio.ParseTask
  alias Accio.Metadata.Metadata
  alias Accio.Storage.Auth
  alias Accio.Storage.Gist

  @doc """
  Processes parsed arguments of the executable
  """
  @spec process(tuple) :: none
  def process({:config, username, token}) do
    %Auth{token: token, username: username}
    |> Auth.save()
  end

  def process({:config}) do
    puts_description({:config})
  end

  def process({:parse}) do
    Auth.get_credentials()
    |> GithubGists.fetch()
    |> handle_gists_response()
  end

  def process({:parse, username, token}) do
    %Auth{username: username, token: token}
    |> GithubGists.fetch()
    |> handle_gists_response()
  end

  def process({:parse_help}) do
    puts_description({:parse})
  end

  def process({:generate, command, path, vars = %{}}) do
    Generator.generate(command, path, vars)
  end

  def process({:generate, command, vars = %{}}) do
    Generator.generate(command, nil, vars)
  end

  def process({:generate, command, path}) do
    Generator.generate(command, path)
  end

  def process{:generate_help, command} do
    command_desc = Gist.get(command).metadata
      |> Metadata.get(:command, :description)

    puts_description({:generate, command, command_desc})
  end

  def process({:generate_help}) do
    puts_description({:generate})
  end

  def process({:help}) do
    puts_description({:help})
  end

  @spec handle_gists_response(tuple) :: none
  defp handle_gists_response({:ok, body}) do
    ParseTask.run(body)
    Output.puts("Gists sucessfully parsed")
  end

  defp handle_gists_response({:error, message}), do:
    Output.error(message)

  @spec puts_description(tuple) :: none
  defp puts_description(args) do
    Descriptions.description(args)
    |> Output.puts()
  end
end
