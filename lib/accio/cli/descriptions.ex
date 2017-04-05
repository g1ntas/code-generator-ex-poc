defmodule Accio.CLI.Descriptions do
  @moduledoc """
  This module contains descriptions (help texts) of all executable commands.
  """

  @doc """
  Returns description for a certain command.
  """
  @spec description(tuple) :: binary
  def description({:config}) do
    """
      ~y~Usage:
        ~d~config <username> <token> [options]

      ~y~Options:
        ~g~-h, --help               ~d~Show help.

      ~y~Help:
        ~d~The ~g~config <username> <token>~d~ command generates a config file with
        your credentials inside your home directory. There ~g~<username>~d~ stands
        for your GitHub username and ~g~<token>~d~ for your GitHub personal access
        token.

        Note that you can also specify credentials separately through options,
        without saving them.
    """
  end

  def description({:parse}) do
    """
      ~y~Usage:
        ~d~ parse [options]

      ~y~Options:
        ~g~-h, --help               ~d~Show this screen.
        ~g~-u, --username=USERNAME  ~d~Username of GitHub account.
        ~g~-t, --token=TOKEN        ~d~Personal access token of GitHub account (with permission to access gists).

      ~y~Help:
        ~d~The parse command fetches, parses and saves all metadata defined gists from your GitHub
        account.

        Note that if you want to specify credentials, you must specify both
        username and token.

        ~r~Bad: ~d~parse --username=USERNAME
             parse --token=TOKEN

        ~g~Good: ~d~parse --username=USERNAME --token==TOKEN
    """
  end

  def description({:generate, command, nil}) do
    """
      ~y~Usage:
        ~d~generate #{command} [options]

      ~y~Options:
        ~g~-h, --help               ~d~Show help.
            ~g~--path=PATH          ~d~Specify default path.
    """
  end

  def description({:generate, command, command_description}) do
    description({:generate, command, nil}) <> """
      ~y~Help:
        ~d~#{command_description}
    """
  end

  def description({:generate}) do
    """
      ~y~Usage:
        ~d~generate <command> [options]

      ~y~Options:
        ~g~-h, --help               ~d~Show help.
            ~g~--path=PATH          ~d~Specify default path.

      ~y~Help:
        ~d~Generates parsed gist by specified ~g~command~d~

        ~g~NOTE: ~d~do not forget to parse your gists first by
              running ~g~parse~d~ command
    """
  end

  def description({:help}) do
    """
      ~y~Usage:
        ~d~command [arguments] [options]

      ~y~Options:
        ~g~-h, --help           ~d~Show help screen.

      ~y~Available commands:
        ~g~config               ~d~Set authentification data.
        ~g~parse                ~d~Fetch, parse and save gists locally.
        ~g~generate             ~d~Generate parsed gist as a file.
    """
  end
end
