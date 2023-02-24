parser grammar BisPreProcParser;

options {
    tokenVocab=BisPreProcLexer;
}

preproc_macro: ENTER_MACRO_MODE (
    KW_LINE_MACRO || KW_FILE_MACRO
) EXIT_MACRO_MODE;

preproc_directive: ENTER_DIRECTIVE_MODE (
    preproc_include_directive |
    preproc_line_directive //| //TEST: SourceDocs only
) EXIT_DIRECTIVE_MODE;

preproc_line_directive:
    KW_LINE_DIRECTIVE ABS_DIGITS BIS_SYM_DOUBLE_QUOTE;

preproc_include_directive:
   preproc_script_include_directive |
   preproc_config_include_directive;



preproc_script_include_directive:
   KW_INCLUDE_DIRECTIVE ABS_DOUBLE_QUOTED_STRING;
preproc_config_include_directive:
   KW_INCLUDE_DIRECTIVE ABS_TAGGED_STRING;


