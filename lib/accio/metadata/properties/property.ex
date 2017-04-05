defmodule Accio.Metadata.Properties.Property do
  @doc """
  Validate arguments of the property
  """
  @callback validate(struct) :: {:ok, nil} | {:error, binary}
end