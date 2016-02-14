module JbUtils where

import System.Environment (getArgs)
import System.IO

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

-- Deprecated: apply a fn to each line of file
applyFn :: ([String] -> [String]) -> String -> String -> IO()
applyFn fn inFile outFile = do
    input <- readFile inFile
    writeFile outFile 
      (joinLines 
        (fn 
          (splitLines isEOL input)))

-- Deprecated: main of apply a fn to each line of file
procFile :: ([String] -> [String]) -> IO() 
procFile fn = do
  args <- getArgs
  case args of
    [input,output]  -> applyFn fn input output
    _               -> putStrLn "error: exactly two arguments needed"

-- apply a fn to each line of file
applyFnLine :: (String -> String) -> Handle -> Handle -> IO()  
applyFnLine mapfn inh outh = do 
	ineof <- hIsEOF inh
	if ineof
		then return ()
		else do 
			inpStr <- hGetLine inh
			hPutStrLn outh (mapfn inpStr)
			applyFnLine mapfn inh outh

-- main of apply a fn to each line of file
procFileLn :: (String -> String) -> IO()  
procFileLn mapfn = do 
	args <- getArgs
	case args of 
		[inf, ouf] -> do
       							inh <- openFile inf ReadMode
       							outh <- openFile ouf WriteMode
       							applyFnLine mapfn inh outh
       							hClose inh
       							hClose outh
		_				 	 -> print "error: provide in out files"

