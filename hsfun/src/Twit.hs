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


--authHost = "localhost:8000"
--apiHost = "localhost:8000"
authHost = "api.twitter.com"
apiHost = "api.twitter.com"

twitOAuth :: OAuth
twitOAuth = newOAuth
  { oauthServerName      = authHost
  , oauthConsumerKey     = "nZd6Sbl8mSVB6Ixp0oLtIMQyQ"
  , oauthConsumerSecret  = "oXKq03bJiFlhg1RQ9lLFaz3U56qyj52dyUTVSoMkZLzmitnan9"
  }

twitCred :: Credential
twitCred = newCredential
  "18572476-L4P12BJryNpRIx4ocE85CPnnEqlpaSXFQeoCzbrAZ"
  "hQ7tSFUgBaS57FFP1vYN4g6WzLTgBQHT4B76ZfpsdGeoy"

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
    L8.putStrLn $ responseBody res
    --return $ eitherDecode $ responseBody res

