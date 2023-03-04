parser grammar BisEnforceParser;

options {
    tokenVocab=BisEnforceLexer;
}

@members {

private final List<String> parsedClassNames = new ArrayList<>();
private final List<String> parsedEnumNames = new ArrayList<>();

private final String errorMessageModifiersOnConstruction = "Modifiers are not allowed on constructors and destructors!";
private final String errorMessageWrongDestructor = "Destructors are required to use the name of the class they correspond with!";
private final String errorMessageClassExists = "A class under this name already exists, either rename this class or add 'modded' modifer.";

private boolean isDayZ;
private @org.jetbrains.annotations.Nullable String currentClassname = null;
private @org.jetbrains.annotations.Nullable String currentEnumName = null;


public BisEnforceParser(TokenStream input, boolean isDayZ, List<String> classDictionary, List<String> enumDictionary) {
    this(input);
    this.parsedClassNames.addAll(classDictionary);
    this.parsedEnumNames.addAll(enumDictionary);
    this.isDayZ = isDayZ;
}

private void enterClass(Enforce_classDeclarationContext clazz) {
	this.currentClassname = clazz.className.getText().toLowerCase();

	final Enforce_containerModifierContext modifier = clazz.modifier;

	if(this.parsedClassNames.contains(this.currentClassname)) {
		if(modifier == null || modifier.KW_MODDED_MODIFIER() == null) {
			this.notifyErrorListeners(
				clazz.className,
				errorMessageClassExists,
				clazz.exception
			);
		}
	} else {
		this.parsedClassNames.add(this.currentClassname);
	}
}

private void exitClass() { this.currentClassname = null; }

private void enterEnum(Enforce_enumDeclarationContext enun) {
	this.currentEnumName = enun.enumName.getText().toLowerCase();

	final Enforce_containerModifierContext modifier = enun.modifier;

	if(this.parsedEnumNames.contains(this.currentEnumName)) {
		if(modifier == null || modifier.KW_MODDED_MODIFIER() == null) {
			this.notifyErrorListeners(
				enun.enumName,
				errorMessageClassExists,
				enun.exception
			);
		}
	} else {
		this.parsedEnumNames.add(this.currentEnumName);
	}
}

private void exitEnum() { this.currentEnumName = null; }
}


@init {
this.isDayZ = true;
}

enforce_tree:
    (enforce_topLevelStatement |
    enforce_classMember[false])* EOF;

enforce_topLevelStatement:
    enforce_containerDeclaration |
    enforce_typeDefStatement |
    SYM_SEMICOLON;

enforce_containerDeclaration:
    enforce_containerModifier? {
final Enforce_containerModifierContext singleModifier = ((Enforce_containerDeclarationContext)_localctx).enforce_containerModifier();
    } (
    enforce_classDeclaration[{singleModifier}] |
    enforce_enumDeclaration[{singleModifier}]
);

enforce_enumDeclaration[Enforce_containerModifierContext modifier]: KW_ENUM enumName=ABS_IDENTIFIER {
this.enterEnum(((Enforce_enumDeclarationContext)_localctx));
} enforce_containerInheritance? SYM_LEFT_BRACE
   enforce_enumMember ( (SYM_COMMA | SYM_SEMICOLON | BIS_NEWLINE)* enforce_enumMember )*
   SYM_RIGHT_BRACE {
this.exitEnum();
   };

enforce_enumMember:
    memberName=ABS_IDENTIFIER (OP_ASSIGN memberValu=enforce_expression)?;

enforce_classDeclaration[Enforce_containerModifierContext modifier]: KW_CLASS className=ABS_IDENTIFIER {
this.enterClass(((Enforce_classDeclarationContext)_localctx));
    } (OP_LESS enforce_variableAtom (SYM_COMMA enforce_variableAtom)* OP_MORE)? enforce_containerInheritance? SYM_LEFT_BRACE
       enforce_classMember[true]*
    SYM_RIGHT_BRACE {
this.exitClass();
    };

enforce_classMember[boolean allowConstructors]:
    enforce_anyFunction[allowConstructors] |
    enforce_variableDeclaration[true] SYM_SEMICOLON;

enforce_variableDeclaration[boolean allowVariableModifiers]:
    ({$allowVariableModifiers == true}? enforce_variableModifier)*
    enforce_variableAtom
    (OP_ASSIGN enforce_expression)?;

enforce_variableAtom: variableType=enforce_type variableName=ABS_IDENTIFIER;

enforce_anyFunction[boolean allowConstructors]: enforce_functionModifier*
{
final List<Enforce_functionModifierContext> modifiers = ((Enforce_anyFunctionContext)_localctx).enforce_functionModifier();
}( enforce_normalFunction[{modifiers}] | enforce_voidFunction[allowConstructors, modifiers]);

enforce_normalFunction[List<Enforce_functionModifierContext> modifiers]:

    returnType=enforce_type functionName=ABS_IDENTIFIER enforce_functionEnding[true];

enforce_voidFunction[boolean allowConstructors, List<Enforce_functionModifierContext> modifiers] returns [boolean isConstruction, boolean isDeconstruction]:
    enforce_functionModifier* PKW_VOID deconstruct=SYM_TILDE? functionName=ABS_IDENTIFIER
        {
final Enforce_voidFunctionContext currentCtx = ((Enforce_voidFunctionContext)_localctx);
final String definedFunctionName = currentCtx.functionName.getText().toLowerCase();
final Token deconstructToken = currentCtx.deconstruct;

if(deconstructToken != null) {
    if(!$modifiers.isEmpty()) {
        Enforce_functionModifierContext lastModifier = $modifiers.get($modifiers.size() - 1);
        this.notifyErrorListeners(
        	lastModifier.start,
        	errorMessageModifiersOnConstruction,
        	lastModifier.exception
        );
    } else if(currentClassname == null) {
        this.notifyErrorListeners(
        	deconstructToken,
        	"You have to be inside a class to declare destructors!",
        	null
        );
    } else if(definedFunctionName != this.currentClassname) {
        this.notifyErrorListeners(
        	currentCtx.functionName,
        	errorMessageWrongDestructor,
        	null
        );
    } else {
        $isDeconstruction = true;
    }
} else if(definedFunctionName != null) {
    if(definedFunctionName == this.currentClassname) {
        if(!$modifiers.isEmpty()) {
            Enforce_functionModifierContext lastModifier = $modifiers.get($modifiers.size() - 1);
            this.notifyErrorListeners(
            	lastModifier.start,
            	errorMessageModifiersOnConstruction,
            	lastModifier.exception
            );
        } else {
            $isConstruction = true;
        }
    }
}
} enforce_functionEnding[false];

enforce_functionEnding[boolean requireReturn]:
    enforce_functionParameters enforce_statement;

enforce_functionParameters: SYM_LEFT_PARENTHESIS
    (enforce_functionParameter (SYM_COMMA enforce_functionParameter)*)?
SYM_RIGHT_PARENTHESIS;

enforce_functionParameter:
    enforce_functionParameterModifier* enforce_variableDeclaration[false]; //Skip modifiers, no semicolon

enforce_typeDefStatement: KW_TYPEDEF enforce_type aliasName=ABS_IDENTIFIER;

enforce_scopeEscape_statement: KW_BREAK | KW_CONTINUE | enforce_return_statement[true] | enforce_return_statement[false];

enforce_statement:
    SYM_SEMICOLON                            |
    enforce_scopeEscape_statement            |
    enforce_thread_statement                 |
    enforce_if_statement                     |
    enforce_block_statement                  |
    enforce_switch_statement                 |
    enforce_delete_statement                 |
    enforce_for_statement                    |
    enforce_for_each_statement               |
    enforce_while_statement                  |
    enforce_expressionary_statement          |
    enforce_goto_statement                   |
    enforce_variableDeclaration[true];


enforce_switch_statement: KW_SWITCH enforce_parenthesizedExpression SYM_LEFT_BRACE
    switchLabel+
 SYM_LEFT_BRACE;

switchLabel:(
    KW_CASE enforce_expression  |
    KW_DEFAULT
) SYM_COLON;

enforce_thread_statement: KW_THREAD functionName=ABS_IDENTIFIER;

enforce_goto_statement: KW_GOTO labelName=ABS_IDENTIFIER;

enforce_while_statement: KW_WHILE enforce_parenthesizedExpression enforce_statement;

enforce_return_statement[boolean returnObject]:
   KW_RETURN
   ({$returnObject == true}? enforce_expression);

enforce_for_each_statement: KW_FOREACH SYM_LEFT_PARENTHESIS
    enforce_variableDeclaration[true] (SYM_COMMA enforce_variableDeclaration[true])*
    SYM_COLON enforce_expression enforce_statement;

enforce_for_statement: KW_FOR SYM_LEFT_PARENTHESIS
    enforce_statement SYM_SEMICOLON enforce_expression SYM_SEMICOLON enforce_statement
    SYM_RIGHT_PARENTHESIS enforce_statement;

enforce_delete_statement: KW_DELETE variableName=ABS_IDENTIFIER;

enforce_if_statement: KW_IF enforce_parenthesizedExpression enforce_statement enforce_else_statement?;

enforce_else_statement: KW_ELSE enforce_statement;

enforce_expressionary_statement: enforce_expression SYM_SEMICOLON;

enforce_block_statement: SYM_LEFT_BRACE enforce_statement* SYM_RIGHT_BRACE;

enforce_containerInheritance: ((KW_EXTENDS | SYM_COLON) superClassType=ABS_IDENTIFIER);

enforce_parenthesizedExpression: SYM_LEFT_PARENTHESIS enforce_expression SYM_RIGHT_PARENTHESIS;

enforce_expression:
    <assoc=left> enforce_commonExpression                                                #commonExpression             |
    <assoc=left> enforce_parenthesizedExpression                                         #parenthesizedExpression      |
    <assoc=left> enforce_expression operator=OP_INCREMENT                                #postIncrementationExpression |
    <assoc=left> enforce_expression operator=OP_DECREMENT                                #postDecrementationExpression |
    <assoc=left> enforce_functionCall                                                    #functionCallExpression       |
    <assoc=left> enforce_arrayIndex                                                      #arrayIndexExpression         |
    <assoc=left> enforce_expression operator=SYM_DOT union=enforce_unionable             #unionChangeExpression        |
    <assoc=right> operator=OP_INCREMENT enforce_expression                               #preIncrementationExpression  |
    <assoc=right> operator=OP_DECREMENT enforce_expression                               #preDecrementationExpression  |
    <assoc=right> OP_NEGATE enforce_expression                                           #negatedExpression            |
    <assoc=right> SYM_TILDE enforce_expression                                           #bitwiseNotExpression         |
    <assoc=right> KW_NEW (enforce_functionCall | enforce_type)                           #objectCreationExpression     |
    <assoc=left> enforce_expression OP_MULTIPLY enforce_expression                       #multiplyExpression           |
    <assoc=left> enforce_expression OP_DIVIDE enforce_expression                         #divideExpression             |
    <assoc=left> enforce_expression OP_MODULO enforce_expression                         #modulusExpression            |
    <assoc=left> enforce_expression operator=OP_ADD enforce_expression                   #additionExpression           |
    <assoc=left> enforce_expression operator=OP_SUBTRACT enforce_expression              #subtractionExpression        |
    <assoc=left> enforce_expression OP_LSHIFT enforce_expression                         #leftShiftExpression          |
    <assoc=left> enforce_expression OP_RSHIFT enforce_expression                         #rightShiftExpression         |
    <assoc=left> enforce_expression OP_LESS enforce_expression                           #lessThanExpression           |
    <assoc=left> enforce_expression OP_LESS_EQUAL enforce_expression                     #lessThanEqualExpression      |
    <assoc=left> enforce_expression OP_MORE enforce_expression                           #moreThanExpression           |
    <assoc=left> enforce_expression OP_MORE_EQUAL enforce_expression                     #moreThanEqualExpression      |
    <assoc=left> enforce_expression OP_EQUAL enforce_expression                          #isEqualExpression            |
    <assoc=left> enforce_expression OP_NOT_EQUAL enforce_expression                      #isNotEqualExpression         |
    <assoc=left> enforce_expression OP_BITWISE_AND enforce_expression                    #bitwiseAndExpression         |
    <assoc=left> enforce_expression OP_BITWISE_XOR enforce_expression                    #bitwiseXorExpression         |
    <assoc=left> enforce_expression OP_BITWISE_OR enforce_expression                     #bitwiseOrExpression          |
    <assoc=left> enforce_expression OP_LOGICAL_AND enforce_expression                    #logicalAndExpression         |
    <assoc=left> enforce_expression OP_LOGICAL_OR enforce_expression                     #logicalOrExpression          |
    //Guessing these exist
    <assoc=right> enforce_expression operator=OP_ASSIGN enforce_expression               #assignExpression             |
    <assoc=right> enforce_expression operator=OP_ADD_ASSIGN enforce_expression           #addAssignExpression          |
    <assoc=right> enforce_expression operator=OP_SUB_ASSIGN enforce_expression           #subAssignExpression          |
    <assoc=right> enforce_expression operator=OP_MULTIPLY_ASSIGN enforce_expression      #multiplyAssignExpression     |
    <assoc=right> enforce_expression operator=OP_DIVIDE_ASSIGN enforce_expression        #divideAssignExpression       |
    <assoc=right> enforce_expression operator=OP_LSHIFT_ASSIGN enforce_expression        #leftShiftAssignExpression    |
    <assoc=right> enforce_expression operator=OP_RSHIFT_ASSIGN enforce_expression        #rightShiftAssignExpression   |
    <assoc=right> enforce_expression operator=OP_AND_ASSIGN enforce_expression           #bitwiseAndAssignExpression   |
    <assoc=right> enforce_expression operator=OP_OR_ASSIGN enforce_expression            #bitwiseOrAssignExpression    ;

enforce_arrayIndex: ABS_IDENTIFIER SYM_LEFT_BRACKET enforce_expression SYM_RIGHT_BRACKET;

enforce_unionable: enforce_functionCall | ABS_IDENTIFIER;

enforce_commonExpression:
    enforce_literal |
    enforce_type |
    KW_THIS |
    KW_SUPER;

enforce_literal:
    ABS_NUMBER |
    ABS_STRING |
    enforce_array_literal |
    enforce_boolean_literal;

enforce_array_literal: SYM_LEFT_BRACE (enforce_expression (SYM_COMMA enforce_expression)*)? SYM_RIGHT_BRACE;

enforce_boolean_literal: KW_TRUE | KW_FALSE;

enforce_functionCall: functionName=ABS_IDENTIFIER SYM_LEFT_PARENTHESIS
    (
      enforce_functionCallParameter (SYM_COMMA enforce_functionCallParameter)*
    )? SYM_RIGHT_PARENTHESIS;

enforce_functionCallParameter: (parameterName=ABS_IDENTIFIER OP_ASSIGN)? enforce_expression;

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

enforce_type:
    ABS_IDENTIFIER (OP_LESS (enforce_type (SYM_COMMA enforce_type*)) OP_MORE)?
    (SYM_LEFT_BRACKET SYM_RIGHT_BRACKET)?;

enforce_containerModifier:
    ({this.isDayZ == true}? KW_SEALED_MODIFIER) |
    KW_MODDED_MODIFIER;