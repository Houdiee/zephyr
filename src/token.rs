use logos::Logos;

#[derive(Debug, Clone, Copy)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}

#[derive(Debug)]
pub struct Token<'src> {
    pub kind: TokenKind<'src>,
    pub span: Span,
}

#[derive(Logos, Debug)]
#[logos(skip r"[ \t\r\n\f]+")]
#[logos(skip r"#.*")]
pub enum TokenKind<'src> {
    #[token("let", callback = |_| Keyword::Let)]
    #[token("in", callback = |_| Keyword::In)]
    #[token("if", callback = |_| Keyword::If)]
    #[token("then", callback = |_| Keyword::Then)]
    #[token("else", callback = |_| Keyword::Else)]
    #[token("effect", callback = |_| Keyword::Effect)]
    #[token("depends", callback = |_| Keyword::Depends)]
    #[token("perform", callback = |_| Keyword::Depends)]
    Keyword(Keyword),

    #[regex(r"[0-9]+", |lex| lex.slice().parse::<usize>().ok().map(Literal::Int))]
    #[regex(r"[0-9]+\.[0-9]+", |lex| lex.slice().parse::<f64>().ok().map(Literal::Num))]
    #[regex(r#""[^"]*""#, |lex| Literal::Str(lex.slice()))]
    #[regex(r#"'[^']'"#, |lex| lex.slice().chars().nth(1).map(Literal::Char))]
    #[token("true", callback = |_| Literal::Bool(true))]
    #[token("false", callback = |_| Literal::Bool(false))]
    Literal(Literal<'src>),

    #[regex("[a-zA-Z][a-zA-Z0-9_]*")]
    Identifier(&'src str),

    #[token("(", callback = |_| Delim::LParen)]
    #[token(")", callback = |_| Delim::RParen)]
    #[token("{", callback = |_| Delim::LBrace)]
    #[token("}", callback = |_| Delim::RBrace)]
    #[token(",", callback = |_| Delim::Comma)]
    #[token(".", callback = |_| Delim::Period)]
    #[token(":", callback = |_| Delim::Colon)]
    #[token(";;", callback = |_| Delim::DoubleColon)]
    #[token("->", callback = |_| Delim::SingleArrow)]
    #[token("=>", callback = |_| Delim::DoubleArrow)]
    #[token("!", callback = |_| Delim::Bang)]
    #[token("|", callback = |_| Delim::Bar)]
    #[token("_", callback = |_| Delim::Discard)]
    Delim(Delim),

    #[token("=", callback = |_| Op::Equals)]
    #[token("+", callback = |_| Op::Add)]
    #[token("-", callback = |_| Op::Sub)]
    #[token("*", callback = |_| Op::Mul)]
    #[token("/", callback = |_| Op::Div)]
    Op(Op),
}

#[derive(Debug)]
pub enum Keyword {
    Let,
    In,
    If,
    Then,
    Else,
    Effect,
    Depends,
    Perform,
}

#[derive(Debug)]
pub enum Literal<'src> {
    Int(usize),
    Num(f64),
    Char(char),
    Str(&'src str),
    Bool(bool),
}

#[derive(Debug)]
pub enum Delim {
    LParen,
    RParen,
    LBrace,
    RBrace,
    Comma,
    Period,
    Colon,
    DoubleColon,
    SingleArrow,
    DoubleArrow,
    Bang,
    Bar,
    Discard,
}

#[derive(Debug)]
pub enum Op {
    Equals,
    Add,
    Sub,
    Mul,
    Div,
}
