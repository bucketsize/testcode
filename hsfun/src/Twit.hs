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


--authHost = "localhost:8000"
--apiHost = "localhost:8000"
authHost = "api.twitter.com"
apiHost = "api.twitter.com"

twitOAuth :: OAuth
twitOAuth = newOAuth
  { oauthServerName      = authHost
  , oauthConsumerKey     = ""
  , oauthConsumerSecret  = ""
  }

twitCred :: Credential
twitCred = newCredential
  ""
  ""

data Tweet = Tweet
  { text :: !Text
  , created_at :: !UTCTime
  } deriving (Show, Generic)
instance FromJSON Tweet
instance ToJSON Tweet

timeline name = do
    req <- parseUrlThrow $ "https://"++ apiHost ++"/1.1/statuses/user_timeline.json?screen_name=" ++ name
    signedreq <- signOAuth twitOAuth twitCred req
    manager <- newManager tlsManagerSettings
    res <- httpLbs signedreq manager
    print $ responseBody res
    --return $ eitherDecode $ responseBody res

