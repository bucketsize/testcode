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
import TwitData

apiHost  = "api.twitter.com"
streamHost = "stream.twitter.com"
twitProto = "https"

twitTimelineUrl = twitProto
  ++ "://"
  ++ apiHost
  ++ "/1.1/statuses/user_timeline.json?screen_name="

twitFilterUrl = twitProto
  ++ "://"
  ++ streamHost
  ++ "/1.1/statuses/filter.json?track="

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
    { oauthServerName      = apiHost
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

data MinTweet = MinTweet
  { text        :: Text
  , created_at  :: Text
  } deriving (Show, Generic)
instance FromJSON MinTweet
instance ToJSON MinTweet

timeline name = do
    req  <- parseUrlThrow $ twitTimelineUrl ++ name
    auth <- twitOAuth
    cred <- twitCred
    signedreq <- signOAuth auth cred req
    manager <- noSSLVerifyManager
    res <- httpLbs signedreq manager
    L8.putStrLn $ responseBody res

twitTimeline name = do
    req  <- parseUrlThrow $ twitTimelineUrl ++ name
    auth <- twitOAuth
    cred <- twitCred
    signedreq <- signOAuth auth cred req
    -- manager <- newManager tlsManagerSettings
    manager <- noSSLVerifyManager
    runResourceT $ do
      res <- http signedreq manager
      runConduit $ responseBody res .| mapM_C (lift . print)

twitFilter name = do
    req  <- parseUrlThrow $ twitFilterUrl ++ name
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
                lift $ putStrLn $ text (x :: Tweet)
              Left  e ->
                lift $ print e
           )

parseTweet :: ByteString -> Either String Tweet
parseTweet jsons = eitherDecodeStrict jsons

