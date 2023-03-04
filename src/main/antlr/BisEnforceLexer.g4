lexer grammar BisEnforceLexer;

import BisCommonLexer;

WHITESPACES:          ( NEW_LINE | BIS_WHITESPACE )               -> channel(HIDDEN);
NEW_LINE:              BIS_NEWLINE;

DELIMITED_COMMENT:              '/*' .*? '*/'                     -> channel(HIDDEN);
SINGLE_LINE_COMMENT:            '//' ~[\r\n]*                     -> channel(HIDDEN);
KW_IFDEF:                       '#ifdef' ~[\r\n]*                 -> channel(HIDDEN);
KW_IFNDEF:                      '#ifndef' ~[\r\n]*                -> channel(HIDDEN);
KW_ELSE_DIRECTIVE:              '#else' ~[\r\n]*                  -> channel(HIDDEN);
KW_ENDIF:                       '#endif' ~[\r\n]*                 -> channel(HIDDEN);
KW_DEFINE:                      '#define' ~[\r\n]*                -> channel(HIDDEN);
KW_INCLUDE:                     '#include' ~[\r\n]*               -> channel(HIDDEN);
EMPTY_DELIMITED_COMMENT:        '/*/'                             -> skip;

KW_ENUM:               BIS_KW_ENUM;
KW_CLASS:              BIS_KW_CLASS;
KW_DELETE:             BIS_KW_DELETE;
KW_EXTENDS:            'extends';
KW_BREAK:              'break';
KW_CASE:               'case';
KW_ELSE:                BIS_KW_ELSE;
KW_IF:                  BIS_KW_IF;
KW_FOR:                'for';
KW_CONTINUE:           'continue';
KW_FOREACH:            'foreach';
KW_NEW:                'new';
KW_RETURN:             'return';
KW_THIS:               'this';
KW_THREAD:             'thread';
KW_WHILE:              'while';
KW_AUTO:               'auto';
KW_NULL:               'null' | 'NULL';
KW_SUPER:              'super';
KW_SWITCH:             'switch';
KW_GOTO:               'goto';
KW_POINTER:            'pointer';
KW_DEFAULT:            'default';
KW_TYPEDEF:            'typedef';
KW_TRUE:               'true';
KW_FALSE:              'false';


//PSUDO-KEYWORDS
PKW_FUNC:              'func';
PKW_VOID:              'void';
PKW_TYPENAME:          'typename';

KW_REF_MODIFIER:       'ref' 'erence'?;
KW_NATIVE_MODIFIER:    'native';
KW_AUTOPTR_MODIFIER:   'autoptr';
KW_VOLATILE_MODIFIER:  'volatile';
KW_PROTO_MODIFIER:     'proto';
KW_STATIC_MODIFIER:    'static';
KW_OWNED_MODIFIER:     'owned';
KW_SEALED_MODIFIER:    'sealed';
KW_NOTNULL_MODIFIER:   'notnull';
KW_OUT_MODIFIER:       'out';
KW_INOUT_MODIFIER:     'inout';
KW_PRIVATE_MODIFIER:   'private';
KW_PROTECTED_MODIFIER: 'protected';
KW_EVENT_MODIFIER:     'event';
KW_MODDED_MODIFIER:    'modded';
KW_EXTERNAL_MODIFIER:  'external';
KW_OVERRIDE_MODIFIER:  'override';
KW_CONST_MODIFIER:     'const';
KW_LOCAL_MODIFIER:     'local';


OP_ADD:                BIS_OP_ADD;
OP_SUBTRACT:           BIS_OP_SUBTRACT;
OP_DIVIDE:             BIS_OP_DIVIDE;
OP_MULTIPLY:           BIS_OP_MULTIPLY;
OP_MORE:               BIS_SYM_GREATER_THAN;
OP_LESS:               BIS_SYM_LESS_THAN;

OP_ADD_ASSIGN:         BIS_OP_ADD_ASSIGN;
OP_SUB_ASSIGN:         BIS_OP_SUB_ASSIGN;
OP_MULTIPLY_ASSIGN:    '*=';
OP_MODULO:             '%';
OP_DIVIDE_ASSIGN:      '/=';
OP_LSHIFT_ASSIGN:      '<<=';
OP_RSHIFT_ASSIGN:      '>>=';
OP_AND_ASSIGN:         '&=';
OP_OR_ASSIGN:          '|=';
OP_XOR_ASSIGN:         '^=';
OP_LESS_EQUAL:         '<=';
OP_MORE_EQUAL:         '>=';
OP_BITWISE_OR:         '|';
OP_BITWISE_XOR:        '^';

OP_BITWISE_AND:        '&';
OP_BITWISE_NOT:        '~';
OP_LOGICAL_OR:         '||';
OP_LOGICAL_AND:        '&&';
OP_ASSIGN:             BIS_OP_ASSIGN;

OP_NEGATE:             '!';
OP_INCREMENT:          '++';
OP_DECREMENT:          '--';
OP_EQUAL:              '==';
OP_NOT_EQUAL:          '!=';
OP_LSHIFT:             '<<';
OP_RSHIFT:             '>>';

SYM_LEFT_BRACKET:      BIS_SYM_LEFT_BRACKET;
SYM_RIGHT_BRACKET:     BIS_SYM_RIGHT_BRACKET;
SYM_LEFT_BRACE:        BIS_SYM_LEFT_BRACE;
SYM_RIGHT_BRACE:       BIS_SYM_RIGHT_BRACE;
SYM_LEFT_PARENTHESIS:  BIS_SYM_LEFT_PARENTHESIS;
SYM_RIGHT_PARENTHESIS: BIS_SYM_RIGHT_PARENTHESIS;
SYM_SEMICOLON:         BIS_SYM_SEMICOLON;
SYM_COLON:             BIS_SYM_COLON;
SYM_COMMA:             BIS_SYM_COMMA;
SYM_DOT:               BIS_SYM_PERIOD;
SYM_DOUBLE_QUOTE:      BIS_SYM_DOUBLE_QUOTE;
SYM_ASPERAND:          BIS_SYM_ASPERAND;
SYM_SHAP:              '#';

ABS_IDENTIFIER:        BIS_ABS_IDENTIFIER;
ABS_STRING:            SYM_DOUBLE_QUOTE .*? SYM_DOUBLE_QUOTE;
ABS_NUMBER:            BIS_ANY_NUMBER;


