parser grammar BisPreProcParser;

options {
    tokenVocab=BisPreProcLexer;
}

preproc_tree: (NON_PREPROC | preproc_directive | preproc_macro)* EOF;

preproc_macro: ENTER_MACRO_MODE (

);

preproc_directive: ENTER_DIRECTIVE_MODE (

);

