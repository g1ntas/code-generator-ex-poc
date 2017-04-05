# todo: document module and functions
# todo: write tests
defmodule Accio.Generator do
  @moduledoc """
  Core module for generating file by parsed template.
  """

  alias Accio.CLI.Output
  alias Accio.Metadata.Metadata
  alias Accio.Storage.Gist
  alias Accio.GeneratorIO
  alias Accio.TemplateFunctions

  @import_functions [{TemplateFunctions, [
    camelcase: 1,
    snakecase: 1,
    kebabcase: 1,
    titlecase: 1,
    spacecase: 1,
    first_word: 1,
    pluralize: 1,
    singularize: 1,
    lowercase: 1,
    uppercase: 1,
    capitalize: 1
  ]}]

  @doc """
  Generates file (template) by given command. Second parameter contains
  the default (forced) path, where the file should be generated. Third
  parameter contains default (forced) variables.
  """
  @spec generate(String.t, String.t | nil, map) :: none
  def generate(command, path \\ nil, defined_vars \\ %{}) do
    gist = Gist.get(command)

    vars =
      gist.metadata
      |> Metadata.get(:variables, :definitions)
      |> GeneratorIO.get_vars(defined_vars)

    template = eval_template(gist.template, vars)

    path
    |> GeneratorIO.get_path()
    |> create_file(template)

    Output.puts("File sucessfully generated")
  end

  @spec create_file(binary, binary) :: none
  defp create_file(path, content) do
    path |> Path.dirname() |> File.mkdir_p()
    path |> Path.expand() |> File.write!(content)
  end

  @spec eval_template(binary, list) :: binary
  defp eval_template(body, vars) do
    # todo: pass import functions
    EEx.eval_string(body, vars, functions: @import_functions) |> String.trim()
  end
end
