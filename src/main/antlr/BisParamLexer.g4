lexer grammar BisParamLexer;

import BisPreProcLexer;

WHITESPACES:          ( BIS_NEWLINE | BIS_WHITESPACE )                            -> channel(HIDDEN);

KW_ENUM:               BIS_KW_ENUM;
KW_CLASS:              BIS_KW_CLASS;
KW_DELETE:             BIS_KW_DELETE;

OP_ADD_ASSIGN:         BIS_OP_ADD_ASSIGN;
OP_SUB_ASSIGN:         BIS_OP_SUB_ASSIGN;
OP_ASSIGN:             BIS_OP_ASSIGN;

SYM_SQUARE:            BIS_SYM_LEFT_BRACKET WHITESPACES* BIS_SYM_RIGHT_BRACKET;
SYM_LEFT_BRACE:        BIS_SYM_LEFT_BRACE;
SYM_RIGHT_BRACE:       BIS_SYM_RIGHT_BRACE;
SYM_LEFT_PARENTHESIS:  BIS_SYM_LEFT_PARENTHESIS;
SYM_RIGHT_PARENTHESIS: BIS_SYM_RIGHT_PARENTHESIS;
SYM_SEMICOLON:         BIS_SYM_SEMICOLON;
SYM_COLON:             BIS_SYM_COLON;
SYM_COMMA:             BIS_SYM_COMMA;
SYM_DOUBLE_QUOTE:      BIS_SYM_DOUBLE_QUOTE;
SYM_ASPERAND:          BIS_SYM_ASPERAND;

ABS_IDENTIFIER: [a-zA-Z_] [a-zA-Z_0-9]*;

ABS_STRING: '"'( ('""'|~('"'))*)'"';
ABS_NUMBER: ALL_SIMPLE_NUMERIC | SCIENTIFIC_NUMBER;

fragment GENERIC_NUMBER: ('-')? [0-9]+;
fragment DECIMAL_NUMBER:  GENERIC_NUMBER '.' [0-9]+;
fragment SCIENTIFIC_NUMBER: ALL_SIMPLE_NUMERIC ('e'|'E') ('+'|'-') ALL_SIMPLE_NUMERIC;
fragment ALL_SIMPLE_NUMERIC: DECIMAL_NUMBER | GENERIC_NUMBER;

//-------------------------------------------------=MACRO MODE=---------------------------------------------------------

mode MACRO_MODE;

    KW_EVALUATE: 'EVAL('                                                          -> mode(EVALUATION_MODE);
    KW_EXECUTE:  'EXEC('                                                          -> mode(EVALUATION_MODE);
//-----------------------------------------------=EVALUATION MODE=------------------------------------------------------

mode EVALUATION_MODE;



    EXIT_EVALUATION_MODE: SYM_RIGHT_PARENTHESIS                                   -> mode(DEFAULT_MODE);




