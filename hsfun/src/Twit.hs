{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
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

--authHost = "localhost:8000"
--apiHost = "localhost:8000"
authHost = "api.twitter.com"
apiHost  = "api.twitter.com"

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
    { oauthServerName      = authHost
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

data Tweet = Tweet
  { text :: !Text
  , created_at :: !UTCTime
  } deriving (Show, Generic)
instance FromJSON Tweet
instance ToJSON Tweet

timeline name = do
    req  <- parseUrlThrow $ "https://"++ apiHost ++"/1.1/statuses/user_timeline.json?screen_name=" ++ name
    auth <- twitOAuth
    cred <- twitCred
    signedreq <- signOAuth auth cred req
    -- manager <- newManager tlsManagerSettings
    manager <- noSSLVerifyManager
    res <- httpLbs signedreq manager
    L8.putStrLn $ responseBody res
    --return $ eitherDecode $ responseBody res

