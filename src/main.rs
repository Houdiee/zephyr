use logos::Logos;

use crate::token::{Span, Token, TokenKind};

pub mod token;

fn main() {
    let source = std::fs::read_to_string("manifesto.zph").unwrap();
    let lexer = TokenKind::lexer(&source);

    let tokens: Vec<Result<Token, Span>> = lexer
        .spanned()
        .map(|(token_result, range)| match token_result {
            Ok(kind) => Ok(Token {
                kind,
                span: Span {
                    start: range.start,
                    end: range.end,
                },
            }),
            Err(()) => Err(Span {
                start: range.start,
                end: range.end,
            }),
        })
        .collect();

    for token in tokens {
        println!("{:?}", token);
    }
}
