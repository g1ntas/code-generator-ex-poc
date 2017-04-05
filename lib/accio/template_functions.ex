defmodule Accio.TemplateFunctions do
  @moduledoc """
  Some common functions to be imported into EEx compiler
  """

  @doc """
  Convert string from any format (spaced, dashed, underscored) to camelCase.

  ## Examples
      iex> Accio.TemplateFunctions.camelcase("Lorem ipsum  sit amet")
      "loremIpsumSitAmet"

      iex> Accio.TemplateFunctions.camelcase("Lorem-ipsum-sit-amet")
      "loremIpsumSitAmet"

      iex> Accio.TemplateFunctions.camelcase("Lorem_ipsum_sit_amet")
      "loremIpsumSitAmet"
  """
  @spec camelcase(String.t) :: String.t
  def camelcase(string) do
    string
    |> String.replace(~r/[\s]+/, "_")
    |> Inflex.camelize(:lower)
  end

  @doc """
  Convert string from any format (spaced, dashed, camelcase) to underscored.

  ## Examples
      iex> Accio.TemplateFunctions.snakecase("Lorem ipsum  sit amet")
      "lorem_ipsum_sit_amet"

      iex> Accio.TemplateFunctions.snakecase("Lorem-ipsum-sit-amet")
      "lorem_ipsum_sit_amet"

      iex> Accio.TemplateFunctions.snakecase("loremIpsumSitAmet")
      "lorem_ipsum_sit_amet"
  """
  @spec snakecase(String.t) :: String.t
  def snakecase(string) do
    string
    |> String.replace(~r/[\s]+/, "_")
    |> Inflex.underscore()
  end

  # lorem ipsum sit amet

  @doc """
  Convert string from any format (spaced, underscored, camelcase) to lowercase dashed.

  ## Examples
      iex> Accio.TemplateFunctions.kebabcase("Lorem ipsum  sit amet")
      "lorem-ipsum-sit-amet"

      iex> Accio.TemplateFunctions.kebabcase("LoremIpsumSitAmet")
      "lorem-ipsum-sit-amet"

      iex> Accio.TemplateFunctions.kebabcase("Lorem_Ipsum_Sit_Amet")
      "lorem-ipsum-sit-amet"
  """
  @spec kebabcase(String.t) :: String.t
  def kebabcase(string) do
    string
    |> snakecase()
    |> String.replace(~r/_/, "-")
  end

  @doc """
  Convert string to titlecased (every word starts with uppercase letter).

  ## Examples
      iex> Accio.TemplateFunctions.titlecase("LoRem iPsuM sIt aMeT")
      "Lorem Ipsum Sit Amet"
  """
  @spec titlecase(String.t) :: String.t
  def titlecase(string) do
    words = string |> String.split()
    " " <> new_string = for word <- words, into: "", do: " " <> capitalize(word)
    new_string
  end

  @doc """
  Convert string from camelCase, snake_case or kebab-case to space separated lowercase string

  ## Examples
      iex> Accio.TemplateFunctions.spacecase("loremIpsumSitAmet")
      "lorem ipsum sit amet"

      iex> Accio.TemplateFunctions.spacecase("lorem-ipsum-Sit-Amet")
      "lorem ipsum sit amet"

      iex> Accio.TemplateFunctions.spacecase("lorem_Ipsum_Sit_Amet")
      "lorem ipsum sit amet"
  """
  @spec spacecase(String.t) :: String.t
  def spacecase(string) do
    string
    |> Inflex.underscore()
    |> String.replace(~r/_/, " ")
  end

  @doc """
  Get the first word from the given string.

  ## Examples
      iex> Accio.TemplateFunctions.first_word("Lorem ipsum sit amet")
      "Lorem"
  """
  @spec first_word(String.t) :: String.t
  def first_word(string) do
    [word | _] = String.split(string)
    word
  end

  @doc """
  Get plural form of the given word

  ## Examples
      iex> Accio.TemplateFunctions.pluralize("Butterfly")
      "Butterflies"
  """
  defdelegate pluralize(string), to: Inflex

  @doc """
  Get singular form of the given word

  ## Examples
      iex> Accio.TemplateFunctions.singularize("Butterflies")
      "Butterfly"
  """
  defdelegate singularize(string), to: Inflex

  @doc """
  Convert all characters in the given string to lowercase.

  ## Examples
      iex> Accio.TemplateFunctions.lowercase("LOREM IPSUM SIT AMET")
      "lorem ipsum sit amet"
  """
  defdelegate lowercase(string), to: String, as: :downcase

  @doc """
  Converts all characters in the given string to uppercase.

  ## Examples
      iex> Accio.TemplateFunctions.uppercase("lorem ipsum sit amet")
      "LOREM IPSUM SIT AMET"
  """
  defdelegate uppercase(string), to: String, as: :upcase

  @doc """
    Convert the first character of string to uppercase and every other character to lowercase

    ## Examples
        iex> Accio.TemplateFunctions.capitalize("lorem Ipsum Sit amet")
        "Lorem ipsum sit amet"
  """
  defdelegate capitalize(string), to: String
end