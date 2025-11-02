grammar Zephyr;

program: statement+ EOF;

statement: KEYWORD_LET | KEYWORD_MUT;

KEYWORD_LET: 'let';
KEYWORD_MUT: 'mut';
KEYWORD_TYPE: 'type';
KEYWORD_IF: 'if';
KEYWORD_THEN: 'then';
KEYWORD_ELSE: 'else';
KEYWORD_MATCH: 'match';
KEYWORD_PERFORM: 'perform';

TYPE_INT: 'Int';
TYPE_DEC: 'Dec';
TYPE_CHAR: 'Char';
TYPE_STR: 'Str';
TYPE_Bool: 'Bool';
TYPE_LIST: 'List';
TYPE_UNIT: 'Unit';

LITERAL_INT: [0-9]+;
LITERAL_DEC: [0-9]+ '.' [0-9]+;
LITERAL_CHAR: '\'' ~['\r\n] '\'';
LITERAL_STR: '"' (~['\r\n])* '"';
LITERAL_BOOL: 'true' | 'false';

IDENT: [a-zA-Z] [a-zA-Z0-9]+; 

DELIM_SEMI: ';';
DELIM_COLON: ':';
DELIM_COMMA: ',';
DELIM_LPAREN: '(';
DELIM_RPAREN: ')';
DELIM_LBRACK: '[';
DELIM_RBRACK: ']';
DELIM_LBRACE: '{';
DELIM_RBRACE: '}';
DELIM_ARROW: '->';
DELIM_RANGE: '..';
DELIM_PERIOD: '.';

OP_EQ: '=';
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
