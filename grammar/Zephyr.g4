grammar Zephyr;

program: statement+ EOF;

statement: KEYWORD_LET | KEYWORD_MUT;

KEYWORD_LET: 'let';
KEYWORD_MUT: 'mut';

WS: [ \t\r\n]+ -> skip;
