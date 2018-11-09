**NOTE:** I created this project for learning purposes. Unfortunatelly, I am not going to finish this project, though I am still working on the idea and currently implementing it in Python. 

Also, I changed the concept of the idea quite a lot, a few  main changes are that instead of gists, git repositories will be used and templates will allow to use embeded python scripts. Templates examples can be found in github.com/g1ntas/accio-templates repository. If someone's interested in project I gladly would use some help.

# Accio
**Accio** is a CLI tool, which allows to generate code templates parsed from the GitHub gists. 


The best way to explain what **Accio** exactly does is a simple scenario: first, you add a gist with your own code template and defined metadata (command name, description, variables) at the top of the gist. Then you can use this tool to parse your defined template from GitHub and then use your specified command to generate this template in your preferred path with values of defined variables used in the template.

![](https://github.com/g1ntas/accio/raw/master/docs/example.gif)

## Prerequisites
**Accio** requires [Erlang 19](http://www.erlang.org/downloads) to be installed in your system. As long as Erlang is installed and works in your system, there should not be any platform compatibility issues.

## Installation

### If you have `wget` installed
1. Run `wget https://github.com/g1ntas/accio/raw/master/dist/accio`
2. Then move `accio` executable to your `PATH` directory e.g. `mv accio /usr/local/bin/accio`

### If you have `curl` installed
1. Run `curl -# "https://github.com/g1ntas/accio/raw/master/dist/accio" -o "accio"`
2. Then move `accio` executable to your `PATH` directory e.g. `mv accio /usr/local/bin/accio`

### Manually
Download [Accio](https://github.com/g1ntas/accio/raw/master/dist/accio) and move it to your preferred location. 

**NOTE:** for OS X users *homebrew* support will be added soon. 

## How to use?

### Configuration
Go to your [GitHub personal access tokens manager](https://github.com/settings/tokens) and generate new token (it is important to select `gist` from the scopes list).
Then run `accio config <username> <personal_access_token>`, where `<username>` stands for your GitHub username and `<personal_access_token>` for your generated token.

### Generation
First create a [gist](https://gist.github.com/) in your GitHub account:
```
<%#
  @command("module")
  @variables({name: "default"})
%>
  
defmodule <%= name %> do
 
end
```

Then parse the gist and save it locally with `accio parse`.

After that, your command is ready and you can generate the file with
`accio generate module`

Run `accio help` to get more information about commands.

## Metadata
Metadata is used to define the data for your template, like command name and variables.

**NOTE:** when parsing the gists, **accio** checks all of your gists and looks for metadata definition at the top of the gist. So, if gist contains any symbols (excluding whitespace) before metadata definition, it will not be parsed.

So far there are 2 properties: `@command` and `@variables`

### `@command(name, description)`
This property sets the name of the command to be used for a file generation. Also, this property is required, because there is no any other way to generate the file without specifying the command.

*`name` (string)* - it is the name of the command. It can contain alphabetical symbols, digits, dashes, colons and underscores, but can not start/end with dash or colon.

*`description` (string)* - this is the description of the command. It is printed when the command is called with `help` flag, e.g. `accio generate command --help`

Example:
`@command("demo:greeting", "Says hello to specified name")`

### `@variables(variables)`
This property defines all the variables used in the template engine. When generating the file, all defined variables are prompted for a value.

*`variables` (map)* - it is a map containing all variables.

Example:
`@variables({var1: "default_value", var2: 10, var3: true})`

**NOTE:** data types of the variables are resolved by the default values, so `var1` from the example will be resolved as `string` and `var2` as `integer`. When prompted, only value of the resolved data type is accepted.

### Data types

*`string`* - strings are inserted between double quotes, and they are encoded in UTF-8. Strings can also have line breaks in them. You can introduce them using escape sequences, e.g. `"first line \n second line"`.

*`integer`* - a number with no fractional part, e.g. `10`.

*`float`* - a number with fractional part, e.g. `10.0`.

*`boolean`* - predicate `true` or `false`.

*`list`* - uses square brackets to specify a list of values. Values can be of any type. e.g. `["test", 2, true, [], {}]`.

*`map`* - same as list, but can have named values and so be easily accessed, e.g. `{key: "value", test: 5}`. Later you can easily access keys of map, like `map.key` or `map.test`.

## Templating engine
Templating engine used by **Accio** is  [EEx](https://hexdocs.pm/eex/EEx.html). This engine is based by macros of Elixir programming language, so it is possible to use macros (ifs, loops...) and functions provided by Elixir.

### Tags
> EEx.SmartEngine supports the following tags:
>  ```
>  <% Elixir expression - inline with output %>
>  <%= Elixir expression - replace with result %>
>  <%% EEx quotation - returns the contents inside %>
>  <%# Comments - they are discarded from source %>
>  ```
> All expressions that output something to the template must use the equals sign (=). Since everything in Elixir is an expression, there are no exceptions for this rule. For example, while some template languages would special-case if/2 clauses, they are treated the same in EEx and also require = in order to have their result printed:
>  ```
>  <%= if true do %>
>    It is obviously true
>  <% else %>
>    This will never appear
>  <% end %>
>  ```

### Functions
It is possible to use all modules and functions provided by Elixir, but there is also some useful functions provided by **Accio**.

#### `camelcase(string)`
Convert string from any format (spaced, dashed, underscored) to camelCase.

```
  iex> camelcase("Lorem ipsum  sit amet")
  "loremIpsumSitAmet"
  
  iex> camelcase("Lorem-ipsum-sit-amet")
  "loremIpsumSitAmet"
  
  iex> camelcase("Lorem_ipsum_sit_amet")
  "loremIpsumSitAmet"
```

#### `snakecase(string)`
Convert string from any format (spaced, dashed, camelcase) to underscored.

```
  iex> snakecase("Lorem ipsum  sit amet")
  "lorem_ipsum_sit_amet"
  
  iex> snakecase("Lorem-ipsum-sit-amet")
  "lorem_ipsum_sit_amet"
  
  iex> snakecase("loremIpsumSitAmet")
  "lorem_ipsum_sit_amet"
```

#### `kebabcase(string)`
Convert string from any format (spaced, underscored, camelcase) to lowercase dashed.

```
  iex> kebabcase("Lorem ipsum  sit amet")
  "lorem-ipsum-sit-amet"
  
  iex> kebabcase("LoremIpsumSitAmet")
  "lorem-ipsum-sit-amet"
  
  iex> kebabcase("Lorem_Ipsum_Sit_Amet")
  "lorem-ipsum-sit-amet"
```

#### `titlecase(string)`
Convert string to titlecased (every word starts with uppercase letter).

```
  iex> titlecase("LoRem iPsuM sIt aMeT")
  "Lorem Ipsum Sit Amet"
```

#### `spacecase(string)`
Convert string from camelCase, snake_case or kebab-case to space separated lowercase string

```
  iex> spacecase("loremIpsumSitAmet")
  "lorem ipsum sit amet"
  
  iex> spacecase("lorem-ipsum-Sit-Amet")
  "lorem ipsum sit amet"
  
  iex> spacecase("lorem_Ipsum_Sit_Amet")
  "lorem ipsum sit amet"
```

#### `first_word(string)`
Get the first word from the given string.

```
  iex> first_word("Lorem ipsum sit amet")
  "Lorem"
```

#### `pluralize(string)`
Get plural form of the given word

```
  iex> pluralize("Butterfly")
  "Butterflies"
```

#### `singularize(string)`
Get singular form of the given word

```
  iex> singularize("Butterflies")
  "Butterfly"
```

#### `lowercase(string)`
Convert all characters in the given string to lowercase.

```
  iex> lowercase("LOREM IPSUM SIT AMET")
  "lorem ipsum sit amet"
```

#### `uppercase(string)`
Converts all characters in the given string to uppercase.

```
  iex> uppercase("lorem ipsum sit amet")
  "LOREM IPSUM SIT AMET"
```

#### `capitalize(string)`
Convert the first character of string to uppercase and every other character to lowercase

```
  iex> capitalize("lorem Ipsum Sit amet")
  "Lorem ipsum sit amet"
```

### Useful links
- [Elixir documentation](https://hexdocs.pm/elixir)
- [EEx templating engine documentation](https://hexdocs.pm/eex/EEx.html)
- [Elixir basic operators](http://elixir-lang.org/getting-started/basic-operators.html)
- [Case, cond and if in Elixir](http://elixir-lang.org/getting-started/case-cond-and-if.html)
- [Loops](http://elixir-lang.org/getting-started/comprehensions.html)

## TO-DO
- [ ] Improve documentation
- [ ] Write functional tests
- [ ] Add `help` command to output the list of all parsed commands
- [ ] Add more specific metadata syntax errors (add line and column of the error)
- [ ] Add feature to generate several files at once (scaffolding)
- [ ] Add homebrew support
