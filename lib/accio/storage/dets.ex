defmodule Accio.Storage.DETS do
  @moduledoc """
  Small wrapper for Erlang's DETS library

  Read more: http://erlang.org/doc/man/dets.html
  """
  @storage_dir Application.get_env(:accio, :storage_dir)

  @doc """
  Inserts one or more objects into the table. If there already
  exists an object with a key matching the key of some of the given
  objects and the table type is set, the old object will be replaced.

  Read more: http://erlang.org/doc/man/dets.html#insert-2
  """
  @spec insert(atom, atom | binary, any, module) :: :ok | {:error, binary}
  def insert(table, key, data, dets_module \\ :dets) do
    dets_module.insert(table, {key, data})
  end

  @doc """
  Returns a list of all objects with specified key stored in table

  Read more: http://erlang.org/doc/man/dets.html#lookup-2
  """
  @spec read(atom, atom | binary, module) :: {:ok, any} | {:error, atom | binary}
  def read(table, key, dets_module \\ :dets) do
    case dets_module.lookup(table, key) do
      [{_, data}] -> {:ok, data}
      [] -> {:error, :empty}
      error -> error
    end
  end

  @doc """
  Opens a table. An empty Dets table is created if no file exists.

  Read more: http://erlang.org/doc/man/dets.html#open_file-2
  """
  @spec open_file(atom, module) :: {:ok, atom} | {:error, binary}
  def open_file(table, dets_module \\ :dets) do
    File.mkdir_p(@storage_dir)
    dets_module.open_file(table, [type: :set, file: :"#{@storage_dir}/#{table}"])
  end

  @doc """
  Closes a table.

  Read more: http://erlang.org/doc/man/dets.html#close-1
  """
  @spec close_file(atom, module) :: :ok | {:error, binary}
  def close_file(table, dets_module \\ :dets) do
    dets_module.close(table)
  end
end
