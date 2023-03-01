parser grammar BisParamParser;

options {
    tokenVocab=BisParamLexer;
}

import BisPreProcParser;

param_tree: (param_statement)* param_enumDeclaration? EOF; //ENTRY POINT

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
    preproc_directive[false, true]          | /* inSourceDoc = false, inParamFile = true */
    param_classDeclaration                  |
    param_deleteStatement                   |
    param_arrayOperation                    |
    param_parameterStatement                |
    preproc_execute_macro SYM_SEMICOLON     ;

param_parameterStatement: ABS_IDENTIFIER (
    (OP_ASSIGN param_literal) |
    (SYM_SQUARE OP_ASSIGN param_literalArray)
) SYM_SEMICOLON;

param_deleteStatement:
    KW_DELETE ABS_IDENTIFIER SYM_SEMICOLON;

param_arrayOperation:
    ABS_IDENTIFIER SYM_SQUARE (
        (OP_SUB_ASSIGN | OP_ADD_ASSIGN)
        param_literalArray
    ) SYM_SEMICOLON;

param_literal:
    ABS_NUMBER               |
    preproc_macro[true]      | /* inParamFile = true */
    param_string             |
    param_parameterReference ; //@addonName or @"addonName"
param_parameterReference: SYM_ASPERAND (ABS_IDENTIFIER | ABS_STRING);

param_literalArray:
    SYM_LEFT_BRACE
        ((param_literal | param_literalArray) (SYM_COMMA (param_literal | param_literalArray))*)?
    SYM_RIGHT_BRACE;


param_string:
    ABS_STRING |
    BIS_WHITESPACE* ~('}' | ';')* BIS_WHITESPACE*;

