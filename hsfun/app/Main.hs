{-# LANGUAGE OverloadedStrings #-}

import System.Environment (getArgs)
import Net
import Text.XML.HXT.Core
import Text.HandsomeSoup
import qualified Data.ByteString.Char8 as C8
import Twit (twitTimeline, twitFilter, twitUserLookup)

-- main1 = do
--   print("hllo")
--   print(fact 4)
--   readOFile "Lib.hs"
--   readAFile "main.hs"
--   withAFile "main.hs" ReadMode (\handle -> do
--     contents <- hGetContents handle
--     putStr "\n\n::in lambda::\n\n"
--     putStr contents)

-- main2 = do
--   args <- getArgs
--   case args of
--          [method, url] -> do
--             httpDo (method, url)

-- main3 = do
--   args <- getArgs
--   case args of
--     [method, url] -> do
--       (r, _, _) <- httpDo (method, url)
--       let doc = readString [withWarnings no] (C8.unpack r)
--       urls <- runX $ doc >>> css "url" /> getText
--       putStrLn(head urls)

main4 = do
  args <- getArgs
  case args of
    (command:q:_) -> do
      case command of
        "lookupUser" -> do
          print $ "lookupUser: " ++ q
          twitUserLookup q
        "filter" -> do
          print $ "filter: " ++ q
          twitFilter q
    [] -> do
      putStrLn "lookupUser <queryString> | filter <queryString>"

main :: IO ()
main = main4
