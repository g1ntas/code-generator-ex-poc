defmodule Accio.Metadata.Properties.Command do
  @moduledoc """
  Structure for command property
  """

  defstruct [:command, :description]

  @behaviour Accio.Metadata.Properties.Property
  @command_regex ~r/^[\w]+([-\:]*[\w]+)*$/

  def validate(params = %__MODULE__{}) do
    cond do
      params.command === nil ->
        {:error, "Command must be specified"}
      !is_bitstring(params.command) ->
        {:error, "Command must be a string"}
      !is_nil(params.description) and !is_bitstring(params.description()) ->
        {:error, "Description must be a string"}
      !String.match?(params.command, @command_regex) ->
        {:error, "Command can only contain alphabetical symbols, digits, dashes, colons and underscores, and can't start or end with a dash or a colon"}
      :else ->
        {:ok, nil}
    end
  end
end
