grammar TestParamParser;

@header {
    package com.flipperplz.generated.paramfile;
}

param_tree: (param_statement)* param_enumDeclaration? EOF;

param_classDeclaration: KW_CLASS ABS_IDENTIFIER (
    SYM_SEMICOLON | (
        (SYM_COLON ABS_IDENTIFIER)?
        SYM_LEFT_BRACE
            param_statement*
        SYM_RIGHT_BRACE
    ) SYM_SEMICOLON
);

param_enumDeclaration: KW_ENUM (SYM_LEFT_BRACE
    (param_enumValue (SYM_COMMA | SYM_SEMICOLON | WHITESPACES)*)*
SYM_RIGHT_BRACE) SYM_SEMICOLON;

param_enumValue: ABS_IDENTIFIER (OP_ASSIGN ABS_NUMBER)?;

param_statement:
    param_classDeclaration |
    param_deleteStatement |
    param_arrayOperation |
    param_parameterStatement;

param_parameterStatement: ABS_IDENTIFIER (
    (OP_ASSIGN param_literal) |
    (SYM_SQUARE OP_ASSIGN param_literalArray)
) SYM_SEMICOLON;

param_deleteStatement:
    KW_DELETE ABS_IDENTIFIER SYM_SEMICOLON;


param_arrayOperation:
    ABS_IDENTIFIER SYM_SQUARE (OP_SUB_ASSIGN | OP_ADD_ASSIGN) param_literalArray SYM_SEMICOLON;


param_literal: ABS_STRING | ABS_NUMBER;

param_literalArray:
    SYM_LEFT_BRACE
        ((param_literal | param_literalArray) (SYM_COMMA (param_literal | param_literalArray))*)?
    SYM_RIGHT_BRACE;

WHITESPACES: [\r\n \t]                       -> channel(HIDDEN);

KW_ENUM:               'enum';
KW_CLASS:              'class';
KW_DELETE:             'delete';

OP_ADD_ASSIGN:         '+=';
OP_SUB_ASSIGN:         '-=';
OP_ASSIGN:             '=';

SYM_SQUARE:            '[' WHITESPACES* ']';
SYM_LEFT_BRACE:        '{';
SYM_RIGHT_BRACE:       '}';
SYM_SEMICOLON:         ';';
SYM_COLON:             ':';
SYM_COMMA:             ',';
SYM_DOUBLE_QUOTE:      '"';

ABS_IDENTIFIER: [a-zA-Z_] [a-zA-Z_0-9]*;

ABS_STRING: '"'( ('""'|~('"'))*)'"';
ABS_NUMBER: ALL_SIMPLE_NUMERIC | SCIENTIFIC_NUMBER;

fragment GENERIC_NUMBER: ('-')? [0-9]+;
fragment DECIMAL_NUMBER:  GENERIC_NUMBER '.' [0-9]+;
fragment SCIENTIFIC_NUMBER: ALL_SIMPLE_NUMERIC ('e'|'E') ('+'|'-') ALL_SIMPLE_NUMERIC;
fragment ALL_SIMPLE_NUMERIC: DECIMAL_NUMBER | GENERIC_NUMBER;