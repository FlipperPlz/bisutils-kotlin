parser grammar BisEnforceParser;

options {
    tokenVocab=BisEnforceLexer;
}

@members {
private String currentClassname = null;
private final String errorMessageModifiersOnConstruction = "Modifiers are not allowed on constructors and destructors!";
private final String errorMessageWrongDestructor = "Destructors are required to use the name of the class they correspond with!";

private boolean isDayZ;

public BisEnforceParser(TokenStream input, boolean isDayZ) {
    this(input);
    this.isDayZ = isDayZ;
}
}


@init {
this.isDayZ = true;
}

enforce_tree:
    (enforce_topLevelStatement |
    enforce_classMember[false])* EOF;

enforce_topLevelStatement:
    enforce_containerDeclaration |
    enforce_typeDefStatement;

enforce_containerDeclaration:
    enforce_containerModifier (
        enforce_classDeclaration |
        enforce_enumDeclaration
    );

enforce_enumDeclaration: KW_ENUM enumName=ABS_IDENTIFIER enforce_containerInheritance? BIS_SYM_LEFT_BRACE
        enforce_enumMember ( (SYM_COMMA | SYM_SEMICOLON | BIS_NEWLINE)* enforce_enumMember )*
BIS_SYM_RIGHT_BRACE;

enforce_enumMember:
    memberName=ABS_IDENTIFIER (OP_ASSIGN memberValu=enforce_expression[false])?;

enforce_classDeclaration: KW_CLASS className=ABS_IDENTIFIER {
this.currentClassname = $className.getText();
    } enforce_containerInheritance? BIS_SYM_LEFT_BRACE
        enforce_classMember[true]*
    BIS_SYM_RIGHT_BRACE {
this.currentClassname = null;
    };

enforce_classMember[boolean allowConstructors]:
    enforce_anyFunction[allowConstructors] |
    enforce_variableDeclaration[true, true];

enforce_variableDeclaration[boolean allowVariableModifiers, boolean includeSemicolon]:
    ({$allowVariableModifiers == true}? enforce_variableModifier)*
    variableType=ABS_IDENTIFIER variableName=ABS_IDENTIFIER
    (OP_ASSIGN enforce_expression[false])?
    ({$includeSemicolon}? SYM_SEMICOLON);

enforce_anyFunction[boolean allowConstructors]:
    enforce_voidFunction[allowConstructors] |
    enforce_normalFunction;

enforce_normalFunction:
    enforce_functionModifier* returnType=ABS_IDENTIFIER enforce_functionEnding[true];

enforce_voidFunction[boolean allowConstructors] returns [boolean isConstruction, boolean isDeconstruction]: (
    mods=enforce_functionModifier* PKW_VOID deconstruct=SYM_TILDE? functionName=ABS_IDENTIFIER
        {
final String definedFunctionName = $functionName.getText().toLowerCase();
final Enforce_functionModifierContext mods = ((Enforce_voidFunctionContext)_localctx).mods;

if($deconstruct != null && $deconstruct.getText() == "~") {

    if(!mods.isEmpty()) {
        this.notifyErrorListeners(
            this.getCurrentToken(),
            errorMessageModifiersOnConstruction,
            null
        );
    } else if(currentClassname == null) {
        this.notifyErrorListeners(
            this.getCurrentToken(),
            "You have to be inside a class to declair destructors!",
            null
        );
    } else if(definedFunctionName != this.currentClassname) {
        this.notifyErrorListeners(
            this.getCurrentToken(),
            errorMessageWrongDestructor,
            null
        );
    } else {
        $isDeconstruction = true;
    }
} else if(definedFunctionName != null) {
    if(definedFunctionName == this.currentClassname) {
        if(!mods.isEmpty()) {
            this.notifyErrorListeners(
                this.getCurrentToken(),
                errorMessageModifiersOnConstruction,
                null
            );
        } else {
            $isConstruction = true;
        }
    }
}
}) enforce_functionEnding[false];

enforce_functionEnding[boolean requireReturn]:
    enforce_functionParameters enforce_statement;

enforce_functionParameters: BIS_SYM_LEFT_PARENTHESIS
    (enforce_functionParameter (SYM_COMMA enforce_functionParameter)*)?
BIS_SYM_RIGHT_PARENTHESIS;

enforce_functionParameter:
    enforce_functionParameterModifier enforce_variableDeclaration[false, false]; //Skip modifiers, no semicolon

enforce_typeDefStatement: KW_TYPEDEF; //TODO


enforce_statement:
    enforce_statement_block   |
    enforce_expression[true]  ;

enforce_statement_block: BIS_SYM_LEFT_BRACE enforce_statement* BIS_SYM_RIGHT_BRACE;

enforce_expression[boolean includeSemicolon]:(
    enforce_commonExpression
) ({$includeSemicolon}? SYM_SEMICOLON);

enforce_commonExpression:
    enforce_literal |
    ABS_IDENTIFIER;

enforce_literal:
    ABS_NUMBER | ABS_STRING;

enforce_containerInheritance: ((KW_EXTENDS | SYM_COLON) ABS_IDENTIFIER);

enforce_variableModifier:
    KW_PRIVATE_MODIFIER  |
    KW_PROTECTED_MODIFIER|
    KW_STATIC_MODIFIER   |
    KW_AUTOPTR_MODIFIER  |
    KW_PROTO_MODIFIER    |
    KW_REF_MODIFIER      |
    KW_CONST_MODIFIER    |
    KW_OWNED_MODIFIER    |
    KW_LOCAL_MODIFIER    ;

enforce_functionParameterModifier:
    KW_REF_MODIFIER      |
    KW_NOTNULL_MODIFIER  |
    KW_OUT_MODIFIER      |
    KW_INOUT_MODIFIER    ;

enforce_functionModifier:
    KW_PRIVATE_MODIFIER  |
    KW_EXTERNAL_MODIFIER |
    KW_PROTECTED_MODIFIER|
    KW_STATIC_MODIFIER   |
    KW_OVERRIDE_MODIFIER |
    KW_OWNED_MODIFIER    |
    KW_REF_MODIFIER      |
    KW_PROTO_MODIFIER    |
    KW_NATIVE_MODIFIER   |
    KW_VOLATILE_MODIFIER |
    KW_EVENT_MODIFIER    ;

enforce_containerModifier:
    ({this.isDayZ == true}? KW_SEALED_MODIFIER) |
    KW_MODDED_MODIFIER;
