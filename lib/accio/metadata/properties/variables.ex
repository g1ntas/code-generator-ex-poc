defmodule Accio.Metadata.Properties.Variables do
  @moduledoc """
  Structure for variable property
  """
  defstruct [definitions: %{}]

  @behaviour Accio.Metadata.Properties.Property

  def validate(params = %__MODULE__{}) do
    cond do
      !is_map(params.definitions) ->
        {:error, "Argument of Variables property must be of type map"}
      :else ->
        {:ok, nil}
    end
  end
end
