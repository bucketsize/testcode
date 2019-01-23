import System.Environment (getArgs)
import System.IO
import Data.Char(toUpper)
import Utils

main :: IO ()
main = procFileLn (\x -> map toUpper x)
