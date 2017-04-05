defmodule Accio.Metadata.Metadata do
  @moduledoc """
  Metadata related functionality
  """

  defstruct [:command, :variables]

  @properties %{
    command: Accio.Metadata.Properties.Command,
    variables: Accio.Metadata.Properties.Variables
  }

  @doc """
  Turn AST list into the structure of properties
  """
  @spec parse(list) :: {:ok, %__MODULE__{}} | {:error, atom}
  def parse(ast_list) do
    try do
      list = for {property, args} <- ast_list do
        module = module_by_property(property) |> throw_error()
        parsed_args = args |> parse_args(module)
        apply(module, :validate, [parsed_args]) |> throw_error()

        {property, parsed_args}
      end

      {:ok, struct(__MODULE__, list)}
    catch
      reason -> {:error, reason}
    end
  end

  @doc """
  Get specified argument of the property from metadata.
  """
  @spec get(%__MODULE__{}, atom, atom) :: any
  def get(properties, property, param) do
    with {:ok, params} when not is_nil(params) <- Map.fetch(properties, property) do
      Map.get(params, param)
    else
      _ -> nil
    end
  end

  @spec parse_args(list, module) :: struct
  defp parse_args(ast_args, module) do
    {named_args, pure_args} = ast_args |> Enum.split_with(&(is_tuple(&1)))

    parsed_pure_args = struct_keys(module) |> Enum.zip(pure_args)

    struct(module, named_args ++ parsed_pure_args)
  end

  @spec struct_keys(module) :: list
  defp struct_keys(module) do
    struct(module) |> Map.from_struct() |> Map.keys()
  end

  @spec module_by_property(atom) :: module
  defp module_by_property(property) do
    module = Map.get(@properties, property)

    case(module) do
      nil -> {:error, "Unknown property \"#{property}\""}
      _ -> {:ok, module}
    end
  end

  @spec throw_error(tuple) :: any
  defp throw_error({:error, reason}), do: throw(reason)
  defp throw_error({:ok, value}), do: value
end
