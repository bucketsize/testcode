module Utils where

import System.Environment (getArgs)
import System.IO
import Data.List (lines)
import Text.XML.HXT.Core
import Text.HandsomeSoup
import qualified Data.ByteString.Char8 as C8

isEOL :: Char -> Bool
isEOL c = c == '\r' || c == '\n'

splitOn :: (Char->Bool) -> String -> [String]
splitOn onPredicate cs =
    let (p, s) = break onPredicate cs
     in p: case s of
        ('\r':'\n':rest) -> splitOn onPredicate rest
        ('\r':rest)      -> splitOn onPredicate rest
        ('\n':rest)      -> splitOn onPredicate rest
        _                -> []

joinWith :: String -> [String] -> String
joinWith t [] = ""
joinWith t (x:xs) = x ++ t ++ joinWith t xs

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
