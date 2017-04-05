defmodule Accio.Storage.Auth do
  @moduledoc """
  Contains functions to save and get authentication credentials into/from the storage
  """
  defstruct [:token, :username]

  alias Accio.CLI.Output
  alias Accio.Storage.DETS

  @table :auth

  @doc """
  Saves authentication credentials to the storage
  """
  @spec save(%__MODULE__{}, module) :: :ok | {:error, binary}
  def save(data, storage_module \\ DETS) do
    storage_module.open_file(@table)
    storage_module.insert(@table, :auth, data)
    storage_module.close_file(@table)
  end

  @doc """
  Reads authentication credentials from the storage
  """
  @spec get_credentials(module) :: %__MODULE__{}
  def get_credentials(storage_module \\ DETS) do
    storage_module.open_file(@table)
    data = storage_module.read(@table, :auth)
    storage_module.close_file(@table)
    parse(data)
  end

  @spec parse({:ok, %__MODULE__{}} | {:error, binary}) :: %__MODULE__{}
  defp parse({:ok, auth}), do: auth
  defp parse({:error, _}) do
    Output.error """
      There was an error reading credentials from the config file.

      It could be, that you hadn't specified your credentials, if so, you can do it in 2 ways:
      1. Run config <username> <token>
      2. Run sync --username=USERNAME --token=TOKEN

      For more information run each command with --help flag
    """

    exit(:shutdown)
  end
end
