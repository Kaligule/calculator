module Main where

import Calculator.AST
import Calculator.Interpreter
import Calculator.Parser

main :: IO ()
main = do
    interact calc
    putStrLn ""

calc s = case parseExp s of
    Left e -> show e
    Right exp -> show $ eval exp