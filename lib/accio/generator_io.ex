defmodule Accio.GeneratorIO do
  @moduledoc """
  Contains functions to interact with user and process provided data
  """

  alias Accio.CLI.Input
  alias Accio.CLI.Output
  alias Accio.Metadata.TypeCaster

  @doc """
  Prompts user a path where to generate the file. If entered path exists,
  prompts if user would like to replace an existing path.

  If path parameter is given, it just checks if the path is free,
  and if not asks to replace the file.
  """
  @spec get_path(String.t, module) :: binary
  def get_path(path, file_module \\ File)
  def get_path(nil, file_module), do: prompt_file_path(file_module)
  def get_path(path, file_module), do: confirm_replace(path, file_module)

  @doc """
  Prompts for value of each given variable (first parameter).
  Each given value is type casted (resolved by the default value), and
  if it doesn't match correct type, shows error. Second parameter contains
  all variables with already set values. If values are incorrect (doesn't contain
  correct syntax by the type of original default value) they are still prompted.
  """
  @spec get_vars(map, map) :: list
  def get_vars(variables, defined_vars) do
    defined_vars = filter_valid_vars(variables, defined_vars)

    # filter variables to prompt
    {_, undefined_vars} =
      variables
      |> Map.split(defined_vars |> Map.keys())

    undefined_vars
    |> prompt_vars()
    |> Map.merge(defined_vars)
    |> Map.to_list()
  end

  @spec prompt_file_path(module) :: binary
  defp prompt_file_path(file_module) do
    Input.read_required("Specify the path, where do you want to generate file")
    |> confirm_replace(file_module)
  end

  @spec confirm_replace(String.t, module) :: String.t
  defp confirm_replace(path, file_module) do
    if file_module.exists?(path) do
      answer = Input.confirm("File with the same name already exists, do you want to replace it", false)
      if !answer, do: prompt_file_path(file_module), else: path
    else
      path
    end
  end

  @spec prompt_vars(map) :: map
  defp prompt_vars(vars) do
    for {key, value} <- vars, into: %{} do
      prompt_var(key, value)
    end
  end

  @spec prompt_var(String.t, TypeCaster.castable) :: tuple
  defp prompt_var(key, default_value) do
    input = Input.read("Enter the value of the \"~d~#{key}~g~\" variable", default_value)

    with {:ok, casted_value} <- TypeCaster.cast(input, default_value) do
      {key, casted_value}
    else
      {:error, reason} ->
        Output.error("ERROR: #{reason}")
        prompt_var(key, default_value)
    end
  end

  @spec filter_valid_vars(map, map) :: map
  defp filter_valid_vars(variables, defined_vars) do
    for {key, value} <- defined_vars do
      with {:ok, default_value} <- Map.fetch(variables, key),
           {:ok, casted_value} <- TypeCaster.cast(value, default_value) do
        {key, casted_value}
      else
        {:error, reason} ->
          Output.error("ERROR: #{reason}")
          nil
        :error ->
          Output.error("ERROR: unknown variable \"#{key}\"")
          nil
      end
    end
    |> Enum.filter(&(!is_nil(&1)))
    |> Map.new()
  end
end
