lexer grammar BisPreProcLexer;

import BisCommonLexer;

ENTER_DIRECTIVE_MODE:           OCTOTHORPE          -> mode(DIRECTIVE_MODE);
ENTER_MACRO_MODE:               LINE                -> mode(MACRO_MODE);

DELIMITED_COMMENT:              '/*' .*? '*/'       -> channel(HIDDEN);
SINGLE_LINE_COMMENT:            LINE ~[\r\n]*       -> channel(HIDDEN);
EMPTY_DELIMITED_COMMENT:        '/*/'               -> skip;

NON_PREPROC: ~[_#] ~[_#]*?;

fragment LINE:                  '__';
fragment OCTOTHORPE:            '#';

//-----------------------------------------------=DIRECTIVE MODE=-------------------------------------------------------
mode DIRECTIVE_MODE;
    WHITESPACE:                     BIS_WHITESPACE+     -> channel(HIDDEN);

    SYM_LEFT_BRACKET:               BIS_SYM_LEFT_BRACKET;
    SYM_RIGHT_BRACKET:              BIS_SYM_RIGHT_BRACKET;
    SYM_LEFT_PARENTHESIS:           BIS_SYM_LEFT_PARENTHESIS;
    SYM_RIGHT_PARENTHESIS:          BIS_SYM_RIGHT_PARENTHESIS;
    SYM_COMMA:                      BIS_SYM_COMMA;

    KW_UNDEFINE:                    'undef';
    KW_DEFINE:                      'define';
    KW_INCLUDE:                     'include';
    KW_IF:                          BIS_KW_IF;
    KW_IFDEF:                       'ifdef';
    KW_IFNDEF:                      'ifndef';
    KW_ELSE:                        BIS_KW_ELSE;
    KW_ENDIF:                       'endif';

    ABS_IDENTIFIER:                 BIS_ABS_IDENTIFIER;
    EXIT_DIRECTIVE_MODE:            BIS_NEWLINE         -> mode(DEFAULT_MODE);
//-------------------------------------------------=MACRO MODE=---------------------------------------------------------
mode MACRO_MODE;

    KW_LINE:                        'LINE';
    KW_FILE:                        'FILE';

    EXIT_MACRO_MODE:                LINE                -> mode(DEFAULT_MODE);
