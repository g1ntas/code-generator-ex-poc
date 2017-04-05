# todo: document module and functions
defmodule Accio.Metadata.TypeCaster do
  alias Accio.Metadata.Extractor

  @type castable :: integer | float | list | map | String.t

  @spec cast(String.t, castable) :: {:ok, castable} | {:error, String.t}
  def cast(string, value) when is_binary(value), do: {:ok, string}
  def cast(string, value) when is_boolean(value) do
    case String.downcase(string) do
      "true" -> {:ok, true}
      "false" -> {:ok, false}
      _ -> {:error, "Invalid type of the value given (expected: boolean)"}
    end
  end
  def cast(string, value) when is_integer(value) do
    try do
      {:ok, String.to_integer(string)}
    rescue
      ArgumentError -> {:error, "Invalid type of the value given (expected: integer)"}
    end
  end

  def cast(string, value) when is_float(value) do
    try do
      {:ok, String.to_float(string)}
    rescue
      ArgumentError -> {:error, "Invalid type of the value given (expected: float)"}
    end
  end

  def cast(string, value) when is_list(value) or is_map(value) do
    with {:ok, tokens} <- Extractor.extract_tokens(string, :data_type_lexer),
         {:ok, ast} <- Extractor.parse_tokens(tokens, :data_type_parser)
    do
      cond do
        is_list(ast) and is_list(value) -> {:ok, ast}
        is_map(ast) and is_map(value) -> {:ok, ast}
        is_list(value) -> {:error, "Invalid type of the value given (expected: list)"}
        is_map(value) -> {:error, "Invalid type of the value given (expected: map)"}
      end
    else
      error -> error
    end
  end

end