defmodule Accio.CLI.Input do
  @moduledoc """
  Functions to interact with user (prompts)
  """

  alias Accio.CLI.Output

  @doc """
  Reads user's input from IO.
  """
  @spec read(binary, any) :: any
  def read(question, default \\ nil) do
    value = question |> gets(:prompt, default)

    case(value) do
      "" -> default
      _ -> value
    end
  end

  @doc """
  Reads user's input from IO, but if input is empty, then shows
  error and prompts user again until input isn't empty.
  """
  @spec read_required(binary, any) :: any
  def read_required(question, default \\ nil) do
    value = read(question, default)

    cond do
      empty?(value) ->
        Output.error("Value is required")
        read_required(question, default)
      :else -> value
    end
  end

  @doc """
  Reads user's input from IO and returns it as boolean
  """
  @spec confirm(binary, boolean) :: boolean
  def confirm(question, default) when is_boolean(default) do
    answer = question |> gets(:confirm, default) |> String.downcase()

    case(answer) do
      "" -> default
      "y" -> true
      "n" -> false
      _ ->
        Output.error("Invalid value")
        confirm(question, default)
    end
  end

  @spec format(atom, binary, any) :: binary
  defp format(:prompt, question, nil), do: "~g~#{question}: ~d~"
  defp format(:prompt, question, default), do: "~g~#{question} [default: ~d~#{stringify(default)}~g~]: ~d~"
  defp format(:confirm, question, true), do: "~g~#{question} [~d~Y/n~g~]? ~d~"
  defp format(:confirm, question, false), do: "~g~#{question} [~d~y/N~g~]? ~d~"

  @spec empty?(any) :: boolean
  defp empty?(value) do
    cond do
      value === "" or value === nil -> true
      :else -> false
    end
  end

  @spec gets(binary, atom, any) :: any
  defp gets(question, type, default) do
    format(type, question, default)
    |> Output.format()
    |> IO.gets()
    |> String.trim()
  end

  @spec stringify(any) :: String.t
  defp stringify(default) when is_binary(default), do: "\"#{default}\""
  defp stringify(default) when is_integer(default) or is_float(default), do: "#{default}"
  defp stringify(default) when is_map(default) do
    represantation =
      for {key, value} <- default, do: "#{key}: #{stringify(value)}"

    "{#{Enum.join(represantation, ", ")}}"
  end
  defp stringify(default) when is_list(default) do
    represantation = for value <- default, do: "#{stringify(value)}"

    "[#{Enum.join(represantation, ", ")}]"
  end
end
