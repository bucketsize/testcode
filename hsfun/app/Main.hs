{-# LANGUAGE OverloadedStrings #-}
import System.Environment (getArgs)
import Twit (timeline, twitFilter)

-- curl -XPOST https://api.twitter.com/oauth2/token?grant_type=client_credentials -H "authorization:Basic blpkNlNibDhtU1ZCNkl4cDBvTHRJTVF5UTpvWEtxMDNiSmlGbGhnMVJROWxMRmF6M1U1NnF5ajUyZHlVVFZTb01rWkx6bWl0bmFuOQ=="
--
-- main :: IO ()
-- main = do
--   args <- getArgs
--   case args of
--          [method, url] -> do
--             (r, t1, t4) <- httpDo (method, url)
--             print (diffUTCTime t4 t1)

main :: IO ()
main = do
  args <- getArgs
  case args of
    (t:_) -> do
      print $ "topic: " ++ t
      twitFilter t
    [] -> do
      twitFilter "AcheDin"
