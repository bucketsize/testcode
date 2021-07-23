module Utils where

import qualified Data.ByteString.Char8 as C8
import Data.Char
import Data.List (lines)
import System.Directory (doesFileExist)
import System.Environment (getArgs)
import System.IO

import Text.HandsomeSoup
import Text.XML.HXT.Core

import Control.Monad.IO.Class (liftIO)
import Control.Exception (try, Exception, SomeException)
import Control.Monad (forM, forM_)
import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>))

fact :: Int -> Int
fact 0 = 1
fact n = n * fact (n - 1)

caps :: IO ()
caps = do
  contents <- getContents
  putStr (map toUpper contents)

shortLinesOnly :: String -> String
shortLinesOnly input =
  let allLines = lines input
      shortLines = filter (\line -> length line < 10) allLines
      result = unlines shortLines
   in result

shLnOnly :: String -> String
shLnOnly = unlines . filter (\l -> length l < 10) . lines

sLns :: String -> String
sLns = unlines . filter ((< 10) . length) . lines

readFileContent :: FilePath -> IO String
readFileContent path = do
  handle <- openFile path ReadMode
  contents <- hGetContents handle
  hClose handle
  return contents

withFileRead :: FilePath -> IO ()
withFileRead path = do
  withFile
    path
    ReadMode
    (\handle -> do
       contents <- hGetContents handle
       putStr contents)

readFileLnC :: Handle -> (String -> ()) -> IO ()
readFileLnC h fn = do
  eof <- hIsEOF h
  if eof
    then return ()
    else do
      (fmap fn) (hGetLine h)
      readFileLnC h fn

readFileLn :: FilePath -> (String -> ()) -> IO ()
readFileLn path fn = do
  h <- openFile path ReadMode
  readFileLnC h fn

readFileLnsC :: Handle -> [String] -> IO [String]
readFileLnsC h acc = do
  eof <- hIsEOF h
  if eof
    then return acc
    else do
      l <- hGetLine h
      readFileLnsC h (acc ++ [l])

readFileLns :: FilePath -> IO [String]
readFileLns path = do
  h <- openFile path ReadMode
  readFileLnsC h []

withAFile :: FilePath -> IOMode -> (Handle -> IO a) -> IO a
withAFile path mode fn = do
  handle <- openFile path mode
  r <- fn handle
  hClose handle
  return r

mergeSort :: (Ord a) => [a] -> [a]
mergeSort [] = []
mergeSort (x:xs) =
  let l = mergeSort [a | a <- xs, a <= x]
      r = mergeSort [a | a <- xs, a > x]
   in l ++ [x] ++ r

printPairs :: (a -> String) -> [a] -> IO ()
printPairs fn (h:[]) = putStrLn (fn h)
printPairs fn (h:hs) = do
  printPairs fn [h]
  printPairs fn hs

getXmlByXpath r = do
  let doc = readString [withWarnings no] (C8.unpack r)
  urls <- runX $ doc >>> css "url" /> getText
  return (urls)

isEOL :: Char -> Bool
isEOL c = c == '\r' || c == '\n'

joinLines :: [String] -> String
joinLines [] = ""
joinLines (x:xs) = x ++ "\n" ++ joinLines xs

splitOn :: Char -> String -> [String]
splitOn c cs =
  let (h, r) = break (== c) cs
   in h :
      case r of
        "" -> []
        _ -> splitOn c (tail r)

fileExists = doesFileExist

dumpTo :: FilePath -> String -> IO ()
dumpTo fn s = do
  withFile fn WriteMode (\h -> do hPutStr h s)

readFrom :: FilePath -> IO (String)
readFrom fn = do
  withFile fn ReadMode (\h -> do hGetContents h)

toLowerString = map toLower

mayL :: Maybe [a] -> [a]
mayL ma =
  case ma of
    Just a  -> a
    Nothing -> []

findFiles :: FilePath -> IO [FilePath]
findFiles fp = do
  fnsex <- try (getDirectoryContents fp) :: IO (Either SomeException [FilePath])
  case fnsex of
    Left  e -> do
      putStrLn ("ERROR: unable to read " ++ fp)
      return []
    Right fns -> do
      let fns' = filter (`notElem` [".", ".."]) fns
      fps <- forM fns' (\fn -> do
        let fp' = fp </> fn
        isDirectory <- doesDirectoryExist fp'
        if isDirectory
          then findFiles fp'
          else return [fp'])
      return (concat fps)

applyFiles :: FilePath -> (FilePath -> IO a) -> IO [a]
applyFiles fp fun = do
  fnsex <- try (getDirectoryContents fp) :: IO (Either SomeException [FilePath])
  case fnsex of
    Left  e -> do
      putStrLn ("ERROR: unable to read " ++ fp)
      return []
    Right fns -> do
      let fns' = filter (`notElem` [".", ".."]) fns
      fps <- forM
        fns'
        (\fn -> do
          let fp' = fp </> fn
          r <- fun fp'
          isDirectory <- doesDirectoryExist fp'
          if isDirectory
            then applyFiles fp' fun
            else return [r])
      return (concat fps)
