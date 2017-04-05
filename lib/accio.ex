defmodule Accio do
  def main(argv) do
    argv
      |> Accio.CLI.Parser.parse_args
      |> Accio.CLI.Controller.process
  end
end
