import System.Environment (getArgs)
import System.IO
import Data.Char(toUpper)
import JbUtils

main :: IO ()
main = procFileLn (\x -> map toUpper x) 
