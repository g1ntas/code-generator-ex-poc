defmodule Accio.CLI.Output do
  @moduledoc """
  Funtions to output formatted messages
  """

  @style_pattern ~r{(~[a-z0-9]+~)}

  @doc """
  Formats and prints the given text in green color.
  """
  @spec puts(any) :: none
  def puts(content) do
    "~g~#{content}~d~"
    |> format()
    |> IO.puts()
  end

  @doc """
  Formats and prints the given text in red color.
  """
  @spec error(any) :: none
  def error(content) do
    "~r~#{content}~d~"
    |> format()
    |> IO.puts()
  end

  @doc """
  Formats ANSI codes from binary string.

  It splits binary into chunks, separating special format symbols
  and then converts them to corresponding ANSI codes.

  ## Examples

      iex> Accio.CLI.Output.format("~r~Red text ~g~Green text")
      ["\\e[31m", "Red text ", "\\e[32m", "Green text"]
  """
  @spec format(binary) :: list
  def format(content) when is_binary(content) do
    @style_pattern
    |> Regex.split(content, [include_captures: true, trim: true])
    |> Enum.map(&(to_ansi(&1)))
  end

  @spec to_ansi(binary) :: binary
  defp to_ansi(value) do
    case(value) do
      "~g~" -> IO.ANSI.green()
      "~r~" -> IO.ANSI.red()
      "~y~" -> IO.ANSI.yellow()
      "~d~" -> IO.ANSI.default_color()
      _ -> value
    end
  end
end
