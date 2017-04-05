# todo: document module and functions
# todo: write tests
defmodule Accio.ParseTask do
  alias Accio.Wormhole
  alias Accio.CLI.Output
  alias Accio.Metadata.Extractor
  alias Accio.Metadata.Metadata
  alias Accio.Storage.Gist

  @spec run(list) :: none
  def run(gists) do
    {_, supervisor} = Task.Supervisor.start_link()

    gists
    |> Enum.map(&Wormhole.capture(supervisor, fn -> save_gist(&1) end))
    |> parse_responses()
    |> Gist.save()
  end


  @spec save_gist(map) :: {binary, %Metadata{}, binary, binary}
  def save_gist(gist) do
    {filename, body} = get_body(gist)

    with {:ok, ast_list} <- Extractor.extract(body),
         {:ok, metadata} <- Metadata.parse(ast_list),
         command when not is_nil(command) <- Metadata.get(metadata, :command, :command)
    do
      {command, metadata, filename, body}
    else
      nil -> {:error, "Command name is not defined"} |> handle_error(filename)
      error -> handle_error(error, filename)
    end
  end

  @spec get_body(map) :: {binary, binary}
  defp get_body(gist) do
    [{_key, file} | _tail] = gist["files"] |> Enum.to_list()
    %HTTPoison.Response{body: body} = HTTPoison.get!(file["raw_url"])
    {file["filename"], body}
  end

  @spec handle_error(tuple, binary) :: any
  defp handle_error({:error, :no_metadata}, _filename),
    do: Process.exit(self(), {:ok, :skip})
  defp handle_error({:error, reason}, filename) when is_binary(reason),
    do: Process.exit(self(), {:error, {filename, reason}})
  defp handle_error({:ok, value}, _filename),
    do: value

  @spec parse_responses(list) :: map
  defp parse_responses(responses) do
    Enum.reduce(responses, [], fn(response, acc) ->
      case(response) do
        {:ok, {command, metadata, filename, body}} ->
          Output.puts "Command \"#{command}\" from file \"#{filename}\" successfully parsed."
          [%Gist{key: command, metadata: metadata, template: body} | acc]
        {:exit, {:error, {filename, reason}}} ->
          Output.error "Error in file \"#{filename}\": #{reason}."
          acc
        _ -> acc
      end
    end)
  end
end
