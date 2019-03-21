module Utils where

import Data.Char
import System.IO
import Text.XML.HXT.Core
import Text.HandsomeSoup
import qualified Data.ByteString.Char8 as C8

fact :: Int -> Int
fact 0 = 1
fact n = n*fact (n-1)

caps :: IO ()
caps = do
  contents <- getContents
  putStr (map toUpper contents)

shortLinesOnly :: String -> String
shortLinesOnly input =
    let allLines = lines input
        shortLines = filter (\line -> length line < 10) allLines
        result = unlines shortLines
    in  result

shLnOnly :: String -> String
shLnOnly = unlines . filter (\l -> length l < 10) . lines

sLns :: String -> String
sLns = unlines . filter ((<10) . length) . lines

readOFile :: FilePath -> IO ()
readOFile path = do
  handle <- openFile path ReadMode
  contents <- hGetContents handle
  putStr contents
  hClose handle

readAFile :: FilePath -> IO ()
readAFile path = do
    withFile path ReadMode (\handle -> do
        contents <- hGetContents handle
        putStr contents)

withAFile :: FilePath -> IOMode -> (Handle -> IO a) -> IO a
withAFile path mode fn= do
  handle <- openFile path mode
  r <- fn handle
  hClose handle
  return r

mergeSort :: (Ord a) => [a] -> [a]
mergeSort [] = []
mergeSort (x:xs) =
    let l = mergeSort [a | a <- xs, a <= x]
        r = mergeSort [a | a <- xs, a > x]
        in  l ++ [x] ++ r

printPairs :: (a -> String) -> [a] -> IO ()
printPairs fn (h:[]) = putStrLn (fn h)
printPairs fn (h:hs) = do
  printPairs fn [h]
  printPairs fn hs

getXmlByXpath r = do
  let doc = readString [withWarnings no] (C8.unpack r)
  urls <- runX $ doc >>> css "url" /> getText
  return (urls)
