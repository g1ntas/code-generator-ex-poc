defmodule Accio.Storage.Gist do
  @moduledoc """
  Contains functions to save and get gists into/from the storage
  """
  defstruct [:key, :metadata, :template]

  alias Accio.CLI.Output
  alias Accio.Storage.DETS

  @table :gists

  @doc """
  Saves all gists from the list into the storage.
  """
  @spec save([%__MODULE__{}], module) :: :ok | {:error, binary}
  def save(data, storage_module \\ DETS) do
    storage_module.open_file(@table)

    Enum.map(data, fn(gist) ->
      storage_module.insert(@table, gist.key, gist)
    end)

    storage_module.close_file(@table)
  end

  @doc """
  Returns saved gist structure from the storage by the specified key (command name)
  """
  @spec get(binary, module) :: %__MODULE__{}
  def get(key, storage_module \\ DETS) do
    storage_module.open_file(@table)
    data = storage_module.read(@table, key)
    storage_module.close_file(@table)
    parse(data)
  end

  @spec parse({:ok, %__MODULE__{}} | {:error, atom | binary}) :: %__MODULE__{}
  defp parse({:ok, gist}), do: gist
  defp parse({:error, _}) do
    Output.error("ERROR: ~d~command not found")
    exit(:shutdown)
  end
end
