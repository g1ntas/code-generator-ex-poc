
Definitions.

% Ignored tokens
WhiteSpace          = [\x{0009}\x{000B}\x{000C}\x{0020}\x{00A0}]
_LineTerminator     = \x{000A}\x{000D}\x{2028}\x{2029}
LineTerminator      = [{_LineTerminator}]
Ignored             = {WhiteSpace}|{LineTerminator}

% Lexical tokens
Identifier          = [a-zA-Z_][a-zA-Z0-9_]*
Punctuator          = [,:\{\}\[\]]

% Integer
Digit               = [0-9]
NonZeroDigit        = [1-9]
NegativeSign        = -
IntegerPart         = {NegativeSign}?(0|{NonZeroDigit}{Digit}*)
IntValue            = {IntegerPart}

% Float
FractionalPart      = \.{Digit}+
Sign                = [+\-]
ExponentIndicator   = [eE]
ExponentPart        = {ExponentIndicator}{Sign}?{Digit}+
FloatValue          = {IntegerPart}{FractionalPart}|{IntegerPart}{ExponentPart}|{IntegerPart}{FractionalPart}{ExponentPart}

% String Value
HexDigit            = [0-9A-Fa-f]
EscapedUnicode      = u{HexDigit}{HexDigit}{HexDigit}{HexDigit}
EscapedCharacter    = ["\\\/bfnrt]
StringCharacter     = ([^\"{_LineTerminator}]|\\{EscapedUnicode}|\\{EscapedCharacter})
StringValue         = "{StringCharacter}*"

% Boolean Value
BooleanValue        = true|false

Rules.

{Ignored}             : skip_token.
{Punctuator}          : {token, {list_to_atom(TokenChars), TokenLine}}.
{IntValue}            : {token, {integer, TokenLine, TokenChars}}.
{FloatValue}          : {token, {float, TokenLine, TokenChars}}.
{StringValue}         : {token, {string, TokenLine, TokenChars}}.
{BooleanValue}        : {token, {boolean, TokenLine, TokenChars}}.
{Identifier}          : {token, {identifier, TokenLine, TokenChars}}.

Erlang code.