defmodule Accio.Metadata.Extractor do
  @moduledoc """
  Extracts metadata definitions into AST list
  """

  @regex ~r/<%#([^">]*(?:(?:"[^"]*")[^">]*)*)%>/f

  @doc """
  Extract and parse metadata part from the file's body and turn it into an AST list
  """
  @spec extract(binary) :: {:ok, list} | {:error, binary}
  def extract(body) do
    with {:ok, metadata} <- extract_block(body),
         {:ok, tokens} <- extract_tokens(metadata)
    do
      parse_tokens(tokens)
    else
      error -> error
    end
  end

  @doc """
  Parse the extracted tokens by lexer
  """
  @spec parse_tokens(list, atom) :: {:ok, list} | {:error, binary}
  def parse_tokens(tokens, parser \\ :metadata_parser) do
    case tokens |> parser.parse() do
      {:ok, ast} ->
        {:ok, ast}
      {:error, {_, _, [error | _]}} ->
        reason = error
          |> parser.format_error()
          |> List.to_string()
          |> String.capitalize()
        {:error, reason}
    end
  end

  @doc """
  Extract tokens from string
  """
  @spec extract_tokens(binary, atom) :: {:ok, list} | {:error, binary}
  def extract_tokens(metadata, lexer \\ :metadata_lexer) do
    tokens = metadata
      |> String.to_char_list()
      |> lexer.string()

    case(tokens) do
      {:ok, tokens, _line} ->
        {:ok, tokens}
      {:error, {_, _, error}, _line} ->
        reason = lexer.format_error(error) |> List.to_string()
        {:error, "Syntax error: #{reason}"}
    end
  end

  @spec extract_block(binary) :: {:ok, binary} | {:error, binary}
  defp extract_block(body) do
    case Regex.run(@regex, body) do
      nil -> {:error, :no_metadata}
      [_, metadata] -> {:ok, metadata}
    end
  end
end
