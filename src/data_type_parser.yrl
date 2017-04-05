Nonterminals
Document Value List ListValues Map MapValues MapKey.

Terminals 
integer float string boolean identifier '{' '}' '[' ']' ':' ','.

Rootsymbol Document.

Document -> Value : '$1'.

Value -> integer : extract_integer('$1').
Value -> string : extract_quoted_string_token('$1').
Value -> float : extract_float('$1').
Value -> boolean : extract_boolean('$1').
Value -> List : '$1'.
Value -> Map : '$1'.

List -> '[' ']' : [].
List -> '[' ListValues ']' : '$2'.

ListValues -> Value : ['$1'].
ListValues -> Value ',' ListValues : ['$1'] ++ '$3'.

Map -> '{' '}' : #{}.
Map -> '{' MapValues '}' : '$2'.

MapValues -> MapKey ':' Value : #{'$1' => '$3'}.
MapValues -> MapKey ':' Value ',' MapValues : maps:put('$1', '$3', '$5').

MapKey -> identifier : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> list_to_atom(Value).
extract_quoted_string_token({_Token, _Line, Value}) -> unicode:characters_to_binary(lists:sublist(Value, 2, length(Value) - 2)).
extract_integer({_Token, _Line, Value}) -> {Int, []} = string:to_integer(Value), Int.
extract_float({_Token, _Line, Value}) -> {Float, []} = string:to_float(Value), Float.
extract_boolean({_Token, _Line, "true"}) -> true;
extract_boolean({_Token, _Line, "false"}) -> false.