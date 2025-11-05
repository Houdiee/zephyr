grammar Zephyr;

definition
	: definition_value
	| definition_function
	| definition_alias
	| definition_record
	| definition_enum
	;

definition_value: KW_LET binding;

definition_function: KW_LET IDENT (LIT_UNIT | param+) ARROW type effect_sig? EQ expr;
param: LPAREN IDENT type_ann RPAREN;
effect_sig: BANG LBRACE type (type COMMA)* COMMA? RBRACE;

definition_alias: KW_ALIAS IDENT EQ type;

definition_record: KW_TYPE IDENT EQ record_sig_block;
record_sig_block: LBRACE record_field_sig (COMMA record_field_sig)* COMMA? RBRACE;
record_field_sig: IDENT COLON type;

tuple_sig: LPAREN type (COMMA type)* COMMA? RPAREN;

definition_enum: KW_TYPE IDENT EQ BAR? enum_variant (BAR enum_variant)*;
enum_variant
	: IDENT record_sig_block
	| IDENT tuple_sig
	| IDENT type
	| IDENT 
	;

expr_match: KW_MATCH expr (BAR match_arm)+;
match_arm
	: IDENT PERIOD record_sig_block // fix this shit
	| IDENT PERIOD tuple_sig
	| IDENT PERIOD IDENT
	;

expr_let_in: KW_LET binding_list KW_IN expr;
expr_if_else: KW_IF expr KW_THEN expr (KW_ELSE expr)?;
expr_where: expr KW_WHERE binding_list;
expr_list: expr (COMMA expr)* COMMA?;
literal_list: LBRACK expr_list RBACK;
literal_tuple: LPAREN expr_list RPAREN;

binding_list: binding (COMMA binding)* COMMA?;
binding: KW_MUT? IDENT type_ann? OP_EQ expr;

type_ann: COLON type;

expr: expr_additive;
expr_additive: expr_multiplicative ((OP_ADD | OP_SUB) expr_multiplicative)*;
expr_multiplicative: // todo!

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
TYPE_BOOL: 'Bool';
TYPE_UNIT: 'Unit';
TYPE_LIST: 'List';
TYPE_TUPLE: 'Tuple';

LIT_INT: [0-9]+;
LIT_DEC: [0-9]+ '.' [0-9]+;
LIT_CHAR: '\'' ~['\r\n] '\'';
LIT_STR: '"' (~["\r\n])* '"';
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
BANG: '!';

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
