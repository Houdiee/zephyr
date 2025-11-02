grammar Zephyr;

definition
	: definition_value
	| definition_function
	| definition_alias
	| definition_record
	| definition_enum
	;

definition_value: KW_LET IDENT type_ann? EQ expr;

definition_function: KW_LET IDENT (LIT_UNIT | param+) ARROW type EQ expr;
param: LPAREN IDENT type_ann RPAREN;

definition_alias: KW_ALIAS IDENT EQ type;

definition_record: KW_TYPE IDENT EQ record_sig_block;
record_sig_block: LBRACE record_field_sig (COMMA record_field_sig)* COMMA? RBRACE;
record_field_sig: IDENT COLON type;

definition_enum: KW_TYPE IDENT EQ BAR? enum_variant (BAR enum_variant)*;
enum_variant
	: IDENT record_sig_block
	| IDENT type
	| IDENT
	;

expr_let_in: KW_LET KW_MUT? IDENT EQ expr KW_IN expr;
expr_if_else: KW_IF expr KW_THEN expr (KW_ELSE expr)?;
expr_where: expr KW_WHERE variable_binding_list;

KW_LET: 'let';
KW_MUT: 'mut';
KW_IN: 'in';
KW_IF: 'if';
KW_THEN: 'then';
KW_ELSE: 'else';
KW_MATCH: 'match';
KW_WHERE: 'where';
KW_FUN: 'fun';
KW_TYPE: 'type';
KW_ALIAS: 'alias';
KW_PERFORM: 'perform';

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
LIT_UNIT: '()';

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
