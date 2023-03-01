lexer grammar BisPreProcLexer;

import BisCommonLexer;

ENTER_DIRECTIVE_MODE:           BIS_NEWLINE OCTOTHORPE            -> mode(DIRECTIVE_MODE);
ENTER_MACRO_MODE:               LINE                              -> mode(MACRO_MODE);
ENTER_PARENTHESIS_MODE:         BIS_SYM_LEFT_PARENTHESIS       -> pushMode(PARENTHISIS_MODE);
EXIT_PARENTHESIS_MODE:          BIS_SYM_RIGHT_PARENTHESIS      -> popMode;

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

    ABS_IDENTIFIER:                 BIS_ABS_IDENTIFIER;
    ABS_DIGITS:                     BIS_DIGITS;


    ABS_PARAM_INCLUDE_PATH:         BIS_SYM_LESS_THAN BIS_PARAM_STRING_CONTENT* BIS_SYM_GREATER_THAN;

    ABS_INCLUDE_PATH:               BIS_ABS_PARAM_STRING;

    EXIT_DIRECTIVE_MODE:            BIS_NEWLINE                   -> mode(DEFAULT_MODE);


//-------------------------------------------------=MACRO MODE=---------------------------------------------------------
mode MACRO_MODE;

    KW_LINE_MACRO:                  'LINE';
    KW_FILE_MACRO:                  'FILE';
    KW_EXEC_MACRO:                  'EXEC('                        -> mode(SQF_MODE);
    KW_EVAL_MACRO:                  'EVAL('                        -> mode(SQF_MODE);


    EXIT_MACRO_MODE:                LINE                           -> mode(DEFAULT_MODE);
//--------------------------------------------------=SQF MODE=----------------------------------------------------------
mode SQF_MODE;
    SQF_CODE:                       ( ~('(') | ENTER_PARENTHESIS_MODE)+;

    EXIT_SQF_MODE:                  BIS_SYM_RIGHT_PARENTHESIS      -> mode(DEFAULT_MODE);

//---------------------------------------------=PARENTHESIS MODE=-------------------------------------------------------
mode PARENTHISIS_MODE;

    PAREN_CONTENTS: ~(')')+;