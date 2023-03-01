parser grammar BisPreProcParser;

options {
    tokenVocab=BisPreProcLexer;
}

//------------------------------------------------=ENTRY POINTS=--------------------------------------------------------

preproc_macro[boolean isParamFile]: ENTER_MACRO_MODE (
    preproc_file_macro  ||
    preproc_line_macro ||
    preproc_evaluate_macro { isParamFile = true; } ||
    preproc_execute_macro { isParamFile = true; }
) ;

preproc_directive[boolean isSourceDoc, boolean isParamFile]: ENTER_DIRECTIVE_MODE (
    preproc_include_directive[isParamFile] |
    preproc_line_directive {isSourceDoc=true;}| //TEST: SourceDocs only
    preproc_define_directive |
    preproc_undefine_directive |
    preproc_if_directive
) EXIT_DIRECTIVE_MODE;
//---------------------------------------------------=MACROS=-----------------------------------------------------------
preproc_file_macro: KW_FILE_MACRO EXIT_MACRO_MODE;

preproc_line_macro: KW_LINE_MACRO EXIT_MACRO_MODE;

preproc_evaluate_macro: KW_EVAL_MACRO (
    SQF_CODE*
) EXIT_SQF_MODE;

preproc_execute_macro: KW_EXEC_MACRO (
    SQF_CODE*
) EXIT_SQF_MODE;

//-------------------------------------------------=DIRECTIVES=---------------------------------------------------------

preproc_define_directive: KW_DEFINE_DIRECTIVE ABS_IDENTIFIER;

preproc_undefine_directive: KW_UNDEFINE_DIRECTIVE ABS_IDENTIFIER;

preproc_if_directive: (
    (KW_IF_DIRECTIVE | KW_IFDEF_DIRECTIVE | KW_IFNDEF_DIRECTIVE) ABS_IDENTIFIER EXIT_DIRECTIVE_MODE
        ifCode=.*?
    (ENTER_DIRECTIVE_MODE (
        KW_ELSE_DIRECTIVE EXIT_DIRECTIVE_MODE elseCode=.*? ENTER_DIRECTIVE_MODE
    )?  KW_ENDIF_DIRECTIVE)
);

preproc_line_directive:
    KW_LINE_DIRECTIVE ABS_DIGITS BIS_SYM_DOUBLE_QUOTE;

preproc_include_directive[boolean isParamFile]: KW_INCLUDE_DIRECTIVE (
    ABS_INCLUDE_PATH ||
    ABS_PARAM_INCLUDE_PATH { isParamFile = true; }
);



