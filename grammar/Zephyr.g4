grammar Zephyr;
# TODO: FIX BOILERPLATE

definition
	: value_definition
	| type_definition
	;

value_definition: variable_binding | function_binding;

function_binding: KEYWORD_LET IDENT function_params function_return_sig EQ = expr;
function_params: LPAREN RPAREN | (LPAREN IDENT type_ann RPAREN)+;
function_return_sig: ARROW type;

variable_binding_list: variable_binding (COMMA variable_binding)* COMMA?;
variable_binding: KEYWORD_LET KEYWORD_MUT? IDENT type_ann? EQ expr;
type_ann: COLON type;

type_definition
	: alias_definition
	| record_definition
	| enum_definition
	;

alias_definition: KEYWORD_ALIAS IDENT EQ type;

record_definition: KEYWORD_TYPE IDENT LBRACE record_definition_fields RBRACE;
record_definition_fields: field_definition (COMMA field_definition)* COMMA?;
field_definition: IDENT COLON type;

enum_definition: KEYWORD_TYPE IDENT EQ enum_variants;
enum_variants: BAR? enum_variant (BAR enum_variant*;
enum_variant
	: IDENT
	| IDENT type
	| IDENT LBRACE record_definition_fields RBRACE
	;

expr_let_in: KEYWORD_LET KEYWORD_MUT? IDENT EQ expr KEYWORD_IN expr;
expr_if_else: KEYWORD_IF expr KEYWORD_THEN expr (KEYWORD_ELSE expr)?;
expr_where: expr KEYWORD_WHERE variable_binding_list;

KEYWORD_LET: 'let';
KEYWORD_MUT: 'mut';
KEYWORD_IN: 'in';
KEYWORD_IF: 'if';
KEYWORD_THEN: 'then';
KEYWORD_ELSE: 'else';
KEYWORD_MATCH: 'match';
KEYWORD_WHERE: 'where';
KEYWORD_FUN: 'fun';
KEYWORD_TYPE: 'type';
KEYWORD_ALIAS: 'alias';
KEYWORD_PERFORM: 'perform';

TYPE_INT: 'Int';
TYPE_DEC: 'Dec';
TYPE_CHAR: 'Char';
TYPE_STR: 'Str';
TYPE_Bool: 'Bool';
TYPE_LIST: 'List';
TYPE_UNIT: 'Unit';

LIT_INT: [0-9]+;
LIT_DEC: [0-9]+ '.' [0-9]+;
LIT_CHAR: '\'' ~['\r\n] '\'';
LIT_STR: '"' (~['\r\n])* '"';
LIT_BOOL: 'true' | 'false';

IDENT: [a-zA-Z] [a-zA-Z0-9]+; 

SEMI: ';';
COLON: ':';
COMMA: ',';
LPAREN: '(';
RPAREN: ')';
LBRACK: '[';
RBRACK: ']';
LBRACE: '{';
RBRACE: '}';
ARROW: '->';
RANGE: '..';
PERIOD: '.';

EQ: '=';
OP_ADD: '+';
OP_SUB: '-';
OP_MUL: '*';
OP_DIV: '/';
OP_CMP_LT: '<';
OP_CMP_LTE: '<=';
OP_CMP_GT: '>';
OP_CMP_GTE: '>=';
OP_CMP_IS: 'is';
OP_CMP_OR: 'or';
OP_CMP_AND: 'and';

REF: '&';
TERMINATOR: ';;';
WILDCARD: '_';

COMMENT: '#' ~[\r\n]* -> skip;
WS: [ \t\r\n]+ -> skip;
