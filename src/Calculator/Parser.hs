module Calculator.Parser
    (
      parseExp
    ) where

import Calculator.AST

import           Control.Applicative  hiding (many, (<|>))
import           Text.Parsec
import           Text.Parsec.Expr
import           Text.Parsec.Language (haskellStyle)
import qualified Text.Parsec.Token    as P
import           Text.Parsec.String   (Parser)

lexer :: P.TokenParser ()
lexer = P.makeTokenParser (haskellStyle
                               { P.reservedOpNames = ["+", "-", "*", "/"]
                               }
                          )

natural    = P.natural lexer
parens     = P.parens lexer
reservedOp = P.reservedOp lexer

term =  parens expr
    <|> EInt <$> natural
    <?> "term"

table = [ [binary "*" EMul AssocLeft, binary "/" EDiv AssocLeft ]
        , [binary "+" EAdd AssocLeft, binary "-" ESub AssocLeft ]
        ]

prefix  name fun = Prefix  (do { reservedOp name; return fun })
binary  name fun = Infix   (do { reservedOp name; return fun })

expr :: Parser Exp
expr = buildExpressionParser table term <?> "expression"

parseExp :: String -> Either ParseError Exp
parseExp = parse expr ""