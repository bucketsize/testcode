module Utils where

import System.Environment (getArgs)
import System.IO
import Data.List (lines)

-- fn isEOL
-- tokenizer predicate
isEOL :: Char -> Bool
isEOL c = c == '\r' || c == '\n'

-- fn splitToLines
splitOn :: (Char->Bool) -> String -> [String]
splitOn onPredicate cs =
    let (p, s) = break onPredicate cs
    in p: case s of
        ('\r':'\n':rest) -> splitOn onPredicate rest
        ('\r':rest)      -> splitOn onPredicate rest
        ('\n':rest)      -> splitOn onPredicate rest
        _                -> []

-- fn joinLines
joinLines :: [String] -> String
joinLines [] = ""
joinLines (x:xs) = x ++ "\n" ++ joinLines xs


-- apply a fn to each line of file
applyFnLn :: (String -> String) -> Handle -> Handle -> IO()  
applyFnLn mapfn inh outh = do 
	ineof <- hIsEOF inh
	if ineof
		then return ()
		else do 
			inpStr <- hGetLine inh
			hPutStrLn outh (mapfn inpStr)
			applyFnLn mapfn inh outh

-- main of apply a fn to each line of file
procFileLn :: (String -> String) -> IO()  
procFileLn mapfn = do 
	args <- getArgs
	case args of 
		[inf, ouf] -> do
       							inh <- openFile inf ReadMode
       							outh <- openFile ouf WriteMode
       							applyFnLn mapfn inh outh
       							hClose inh
       							hClose outh
		_				 	 -> print "error: provide in out files"

