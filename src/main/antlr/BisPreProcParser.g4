parser grammar BisPreProcParser;

options {
    tokenVocab=BisPreProcLexer;
}

preproc_macro: ENTER_MACRO_MODE (
    KW_LINE_MACRO || KW_FILE_MACRO
) EXIT_MACRO_MODE;

preproc_directive: ENTER_DIRECTIVE_MODE (
    preproc_include_directive |
    preproc_line_directive | //TEST: SourceDocs only
    preproc_define_directive |
    preproc_undefine_directive |
    preproc_if_directive
) EXIT_DIRECTIVE_MODE;

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

preproc_include_directive:
    KW_INCLUDE_DIRECTIVE ABS_INCLUDE_PATH;



