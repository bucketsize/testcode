{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Twit where

import Data.ByteString (ByteString)
import Network.HTTP.Conduit
import Web.Authenticate.OAuth
import Data.Aeson
import Data.Time.Clock (UTCTime)
import Data.Text (Text)
import GHC.Generics
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.ByteString.Char8 as C8
import System.Environment
import Network.Connection
import Conduit
import qualified Data.Text as T
import Data.Text.Encoding
import Data.List.Split
import Data.List
import qualified Data.Map.Strict as Map
import TwitData
import qualified TwitData as TW

twitTimelineUrl   = "https://api.twitter.com/1.1/statuses/user_timeline.json?"
twitFilterUrl     = "https://stream.twitter.com/1.1/statuses/filter.json?"
twitUserLookupUrl = "https://api.twitter.com/1.1/users/lookup.json?"

noSSLVerifyManager :: IO Manager
noSSLVerifyManager =
  let tlsSettings = TLSSettingsSimple {
      settingDisableCertificateValidation = True
      , settingDisableSession=False
      , settingUseServerName=True
      }
   in newManager $ mkManagerSettings tlsSettings Nothing

twitOAuth :: IO OAuth
twitOAuth = do
  key <- getEnv "TwitConKey"
  sec <- getEnv "TwitConSec"
  return newOAuth
    { oauthServerName      = "api.twitter.com"
    , oauthConsumerKey     = C8.pack key
    , oauthConsumerSecret  = C8.pack sec
    }

twitCred :: IO Credential
twitCred = do
  tok <- getEnv "TwitAccTok"
  sec <- getEnv "TwitAccSec"
  return $ newCredential
    (C8.pack tok)
    (C8.pack sec)

twitTimeline name = do
    req  <- parseUrlThrow $ twitTimelineUrl ++ name
    auth <- twitOAuth
    cred <- twitCred
    signedreq <- signOAuth auth cred req
    manager <- noSSLVerifyManager
    res <- httpLbs signedreq manager
    L8.putStrLn $ responseBody res

splitQE :: String -> (String, String)
splitQE qe =
  let qis = splitOn "=" qe
      k = qis !! 0
      v = qis !! 1
  in (k, v)

splitQS :: String -> Map.Map String String
splitQS qs = Map.fromList
  $ map splitQE
  $ splitOn "&" qs

joinQS :: Map.Map String String -> String
joinQS qm = intercalate "&"
  $ map (\(k, v) -> k ++ "=" ++ v )
  $ Map.toList qm

twitUserLookup query = do
    req  <- parseUrlThrow $ twitUserLookupUrl ++ query
    auth <- twitOAuth
    cred <- twitCred
    signedreq <- signOAuth auth cred req
    manager <- noSSLVerifyManager
    res <- httpLbs signedreq manager
    -- L8.putStrLn $ responseBody res
    let users = parseUsers $ responseBody res
    case users of
      Right us -> mapM_ (\u ->
        putStrLn $ intercalate ":" [ screen_name (u :: User)
                   , name (u :: User)
                   , id_str (u :: User)
                   , case location (u :: User) of
                       Just l -> l
                       Nothing-> "Unknown"
                   ]) us
    return users

twitSnToId :: String -> IO String
twitSnToId query = do
    let qm = splitQS query
    let sn = Map.lookup "follow" qm
    -- print $ query
    -- print $ qm
    -- print $ sn
    case sn of
      Just sns -> do
        users <- twitUserLookup $ "screen_name="++sns
        return $ case users of
          Right us ->
            let ids = intercalate "," $ map (\ui -> show $ TW.id (ui :: User)) us
                qm1 = Map.insert "follow" ids qm
            in joinQS qm1
          Left e -> query
      Nothing -> do
        return query

twitFilter query = do
    query1 <- twitSnToId query
    req  <- parseUrlThrow $ twitFilterUrl ++ query1
    auth <- twitOAuth
    cred <- twitCred
    signedreq <- signOAuth auth cred req
    manager <- noSSLVerifyManager
    runResourceT $ do
      res <- http signedreq manager
      lift $ print $ responseStatus res
      lift $ mapM_ (\h -> print h) $ responseHeaders res
      -- runConduit $ responseBody res .| sinkFile "/var/tmp/tw-filter"
      runConduit
        $ responseBody res
        .| mapMC (\s ->  do
            -- lift $ C8.putStrLn s
            return $ parseTweet s)
        .| mapM_C (\s ->  do
            case s of
              Right x ->
                lift $ putStrLn
                  $ intercalate "\n" [ "<Tweet>"
                                     , TW.id_str ((TW.user (x :: Tweet)) :: User)
                                     , TW.screen_name $ TW.user (x :: Tweet)
                                     , TW.text (x :: Tweet)
                                     , "</Tweet>"
                                     ]
              Left  e ->
                lift $ print e
           )

parseUsers :: L8.ByteString -> Either String [User]
parseUsers jsons = eitherDecode jsons

parseTweet :: ByteString -> Either String Tweet
parseTweet jsons = eitherDecodeStrict jsons

