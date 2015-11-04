module JbUtils where

import System.Environment (getArgs)

-- fn isEOL
-- tokenizer predicate
isEOL :: Char -> Bool
isEOL c = c == '\r' || c == '\n'

-- fn splitToLines
splitLines :: (Char->Bool) -> String -> [String]
splitLines onPredicate cs =
    let (p, s) = break onPredicate cs
    in p: case s of
        ('\r':'\n':rest) -> splitLines onPredicate rest
        ('\r':rest)      -> splitLines onPredicate rest
        ('\n':rest)      -> splitLines onPredicate rest
        _                -> []

-- fn joinLines
joinLines :: [String] -> String
joinLines [] = ""
joinLines (x:xs) = x ++ "\n" ++ joinLines xs

-- fn procFile
applyFn fn inFile outFile = do
    input <- readFile inFile
    writeFile outFile 
      (joinLines 
        (fn 
          (splitLines isEOL input)))

-- fn runMain
procFile fn = do
  args <- getArgs
  case args of
    [input,output]  -> applyFn fn input output
    _               -> putStrLn "error: exactly two arguments needed"

