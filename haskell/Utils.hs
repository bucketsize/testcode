module Hw.Utils where

import System.Environment (getArgs)
import System.IO
import Data.List (lines)
import System.IO.Streams.File

-- fn isEOL
-- tokenizer predicate
isEOL :: Char -> Bool
isEOL c = c == '\r' || c == '\n'

-- fn splitToLines
splitOn :: (Char -> Bool) -> String -> [String]
splitOn onPredicate cs =
  let (p, s) = break onPredicate cs
   in p: case s of
           ('\r':'\n':rest) -> splitOn onPredicate rest
           ('\r':rest) -> splitOn onPredicate rest
           ('\n':rest) -> splitOn onPredicate rest
           (' ':rest) -> splitOn onPredicate rest
           "" -> []

-- fn joinLines
joinLines :: [String] -> String
joinLines [] = ""
joinLines (x:xs) = x ++ "\n" ++ joinLines xs

