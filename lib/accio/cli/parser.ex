defmodule Accio.CLI.Parser do
  @moduledoc """
  Process executable arguments.
  """

  @switches [:username, :token, :path, :help, :vars]

  @aliases [
    u: :username,
    t: :token,
    h: :help,
    v: :vars
  ]

  @doc """
  Parses arguments and returns tuple to use in processor.
  """
  @spec parse_args(list) :: tuple
  def parse_args(argv) do
    {options, args, errors} = OptionParser.parse(argv, allow_nonexistent_atoms: true, aliases: @aliases)

    sorted_options = sort_options(options)

    case({sorted_options, args, errors}) do
      # `config` command
      {[], ["config", username, token], []} -> {:config, username, token}
      {[help: true], ["config"], []} -> {:config}
      {_, ["config" | _], _} -> {:config}

      # `parse` command
      {[], ["parse"], []} -> {:parse}
      {[token: token, username: username], ["parse"], []} -> {:parse, username, token}
      {[help: true], ["parse"], []} -> {:parse_help}
      {_, ["parse" | _], _} -> {:parse_help}

      # `generate` command
      {[], ["generate", command], []} -> {:generate, command, nil}
      {[path: path], ["generate", command], []} -> {:generate, command, path}
      {[{:vars, true} | vars], ["generate", command], []} -> {:generate, command, Map.new(vars)}
      {[{:path, path}, {:vars, true} | vars], ["generate", command], []} -> {:generate, command, path, Map.new(vars)}
      {[help: true], ["generate", command], []} -> {:generate_help, command}
      {[help: true], ["generate"], []} -> {:generate_help}
      {_, ["generate" | _], _} -> {:generate_help}

      # anything else calls help command
      _ -> {:help}
    end
  end

  [help: true, path: "test/file.ex",  var1: "valu1", var2: "value2"]

  # Sort list by moving predefined switches to the front
  @spec sort_options(list) :: list
  defp sort_options(options) do
    {switches, dynamic_options} = options |> Enum.split_with(fn({key, _value}) ->
      Enum.member?(@switches, key)
    end)

    List.keysort(switches, 0) ++ dynamic_options
  end
end
