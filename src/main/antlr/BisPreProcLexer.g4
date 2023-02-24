lexer grammar BisPreProcLexer;

import BisCommonLexer;

ENTER_DIRECTIVE_MODE:           OCTOTHORPE                        -> mode(DIRECTIVE_MODE);
ENTER_MACRO_MODE:               LINE                              -> mode(MACRO_MODE);

DELIMITED_COMMENT:              '/*' .*? '*/'                     -> channel(HIDDEN);
SINGLE_LINE_COMMENT:            LINE ~[\r\n]*                     -> channel(HIDDEN);
EMPTY_DELIMITED_COMMENT:        '/*/'                             -> skip;

fragment LINE:                  '__';
fragment OCTOTHORPE:            '#';

//-----------------------------------------------=DIRECTIVE MODE=-------------------------------------------------------
mode DIRECTIVE_MODE;
    WHITESPACE:                     BIS_WHITESPACE+               -> channel(HIDDEN);

    SYM_LEFT_BRACKET:               BIS_SYM_LEFT_BRACKET;
    SYM_RIGHT_BRACKET:              BIS_SYM_RIGHT_BRACKET;
    SYM_LEFT_PARENTHESIS:           BIS_SYM_LEFT_PARENTHESIS;
    SYM_RIGHT_PARENTHESIS:          BIS_SYM_RIGHT_PARENTHESIS;
    SYM_COMMA:                      BIS_SYM_COMMA;

    KW_UNDEFINE_DIRECTIVE:          'undef';
    KW_DEFINE_DIRECTIVE:            'define';
    KW_INCLUDE_DIRECTIVE:           'include';
    KW_IF_DIRECTIVE:                BIS_KW_IF;
    KW_IFDEF_DIRECTIVE:             'ifdef';
    KW_IFNDEF_DIRECTIVE:            'ifndef';
    KW_ELSE_DIRECTIVE:              BIS_KW_ELSE;
    KW_ENDIF_DIRECTIVE:             'endif';
    KW_LINE_DIRECTIVE:              'line';

    ABS_INCLUDE_PATH:               ABS_TAGGED_STRING | ABS_DOUBLE_QUOTED_STRING | ABS_DOUBLE_QUOTED_STRING;
    ABS_TAGGED_STRING:              BIS_SYM_LESS_THAN .*? BIS_SYM_GREATER_THAN;
    ABS_DOUBLE_QUOTED_STRING:       BIS_SYM_DOUBLE_QUOTE .*? BIS_SYM_DOUBLE_QUOTE;
    ABS_SINGLE_QUOTED_STRING:       '\'' .*? '\'';
    ABS_IDENTIFIER:                 BIS_ABS_IDENTIFIER;
    ABS_DIGITS:                     BIS_DIGITS;


//    NEWLINE:                        '\\' BIS_NEWLINE              -> channel(HIDDEN);

    EXIT_DIRECTIVE_MODE:            BIS_NEWLINE                   -> mode(DEFAULT_MODE);
//-------------------------------------------------=MACRO MODE=---------------------------------------------------------
mode MACRO_MODE;

    KW_LINE_MACRO:                  'LINE';
    KW_FILE_MACRO:                  'FILE';

    EXIT_MACRO_MODE:                LINE                           -> mode(DEFAULT_MODE);
