lexer grammar BisCommonLexer;

BIS_KW_CLASS:              'class';
BIS_KW_ENUM:               'enum';
BIS_KW_DELETE:             'delete';
BIS_KW_IF:                 'if';
BIS_KW_ELSE:               'else';

BIS_SYM_LEFT_BRACKET:      '[';
BIS_SYM_RIGHT_BRACKET:     ']';
BIS_SYM_LEFT_BRACE:        '{';
BIS_SYM_RIGHT_BRACE:       '}';
BIS_SYM_LEFT_PARENTHESIS:  '(';
BIS_SYM_RIGHT_PARENTHESIS: ')';
BIS_SYM_LESS_THAN:         '<';
BIS_SYM_GREATER_THAN:      '>';

BIS_SYM_SEMICOLON:         ';';
BIS_SYM_COLON:             ':';
BIS_SYM_PAA_NEKUDOTAYIM:   '::';
BIS_SYM_COMMA:             ',';
BIS_SYM_DOUBLE_QUOTE:      '"';
BIS_SYM_SINGLE_QUOTE:      '\'';
BIS_SYM_ASPERAND:          '@';
BIS_SYM_PERIOD:            '.';

BIS_OP_ADD_ASSIGN:         '+=';
BIS_OP_SUB_ASSIGN:         '-=';
BIS_OP_ASSIGN:             '=';
BIS_OP_SUBTRACT:           '-';
BIS_OP_ADD:                '+';
BIS_OP_MULTIPLY:           '*';
BIS_OP_DIVIDE:             '/';

BIS_ABS_IDENTIFIER:        [a-zA-Z_] [a-zA-Z_0-9]*;
BIS_ABS_PARAM_STRING:      BIS_SYM_DOUBLE_QUOTE BIS_PARAM_STRING_CONTENT* BIS_SYM_DOUBLE_QUOTE |
                           BIS_SYM_SINGLE_QUOTE BIS_PARAM_STRING_CONTENT* BIS_SYM_SINGLE_QUOTE;

BIS_NEWLINE:               '\r'? '\n';
BIS_WHITESPACE:            [\t ];

fragment BIS_GENERIC_NUMBER:         BIS_NEGATIVE_NUMBER | BIS_DIGITS;
fragment BIS_FRACTIONAL_NUMBER:      BIS_GENERIC_NUMBER BIS_SYM_PERIOD BIS_GENERIC_NUMBER;
fragment BIS_SIMPLE_NUMBER:          BIS_GENERIC_NUMBER | BIS_FRACTIONAL_NUMBER;
fragment BIS_SCIENTIFIC_NUMBER:      BIS_SIMPLE_NUMBER ('e'|'E') ('+'|'-') BIS_SIMPLE_NUMBER;
fragment BIS_ANY_NUMBER:             BIS_SCIENTIFIC_NUMBER | BIS_SIMPLE_NUMBER | BIS_HEX_NUMBER;
fragment BIS_HEX_NUMBER:             '0x' BIS_HEX_CHAR+;
fragment BIS_NEGATIVE_NUMBER:        '-' [0-9]+;
fragment BIS_DIGITS:                 [0-9]+;
fragment BIS_PARAM_STRING_CONTENT:   ('""' | ~('"'));
fragment BIS_HEX_CHAR:              [a-fA-F0-9]+;

