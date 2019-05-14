{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

module TwitData where

import Data.Primitive.Array
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON, Object)

data Tweet = Tweet
  { created_at :: String
  , id :: Float
  , id_str :: String
  , text :: String
  , source :: String
  , truncated :: Bool
  -- , inReplyToStatusID :: Maybe String
  -- , inReplyToStatusIDStr :: Maybe String
  -- , inReplyToUserID :: Maybe String
  -- , inReplyToUserIDStr :: Maybe String
  -- , inReplyToScreenName :: Maybe String
  , user :: User
  , geo :: Maybe String
  , coordinates :: Maybe String
  , place :: Maybe Object
  , contributors :: Maybe String
  -- , quotedStatusID :: Float
  -- , quotedStatusIDStr :: String
  -- , quotedStatus :: QuotedStatus
  -- , quotedStatusPermalink :: QuotedStatusPermalink
  -- , isQuoteStatus :: Bool
  , quote_count :: Int
  , reply_count :: Int
  , retweet_count :: Int
  , favorite_count :: Int
  , entities :: Entities
  , favorited :: Bool
  , retweeted :: Bool
  -- , filterLevel :: String
  , lang :: String
  -- , timestampMS :: String
  } deriving (Show, Generic)

data Entities = Entities
  { hashtags :: Array Hashtag
  , urls :: Array EUrl
  -- , userMentions :: Array String
  , symbols :: Array String
  , media :: Maybe (Array Media)
  } deriving (Show, Generic)

data EUrl = EUrl
  { url :: String
  }deriving (Show, Generic)
data Hashtag = Hashtag
  { text :: String
  , indices :: Array Int
  } deriving (Show, Generic)

data Media = Media
  { id :: Float
  -- , idStr :: String
  , indices :: Array Int

  , url :: String
  -- , displayURL :: String
  -- , expandedURL :: String
  -- , mediaType :: String
  } deriving (Show, Generic)

data QuotedStatus = QuotedStatus
  { created_at :: Maybe String
  , id :: Float
  -- , idStr :: String
  , text :: String
  -- , displayTextRange :: Array Int
  , source :: String
  , truncated :: Bool
  -- , inReplyToStatusID :: Maybe String
  -- , inReplyToStatusIDStr :: Maybe String
  -- , inReplyToUserID :: Maybe String
  -- , inReplyToUserIDStr :: Maybe String
  -- , inReplyToScreenName :: Maybe String
  , user :: User
  , geo :: Maybe String
  , coordinates :: Maybe String
  , place :: Maybe Object
  , contributors :: Maybe String
  -- , isQuoteStatus :: Bool
  -- , quoteCount :: Int
  -- , replyCount :: Int
  -- , retweetCount :: Int
  -- , favoriteCount :: Int
  , entities :: Entities
  -- , extendedEntities :: ExtendedEntities
  , favorited :: Bool
  , retweeted :: Bool
  -- , possiblySensitive :: Bool
  -- , filterLevel :: String
  , lang :: String
  } deriving (Show, Generic)

data ExtendedEntities = ExtendedEntities
  { media :: Array Media
  } deriving (Show, Generic)

data User = User
  { id :: Integer
  , id_str :: String
  , name :: String
  , screen_name :: String
  , location :: Maybe String
  , url :: Maybe String
  , description :: Maybe String
  -- , translatorType :: String
  , protected :: Bool
  , verified :: Bool
  , followers_count :: Int
  -- , friendsCount :: Int
  -- , listedCount :: Int
  -- , favouritesCount :: Int
  -- , statusesCount :: Int
  , created_at :: String
  -- , utcOffset :: Maybe String
  -- , timeZone :: Maybe String
  -- , geoEnabled :: Bool
  , lang :: String
  -- , contributorsEnabled :: Bool
  -- , isTranslator :: Bool
  -- , profileBackgroundColor :: String
  -- , profileBackgroundImageURL :: String
  -- , profileBackgroundImageURLHTTPS :: String
  -- , profileBackgroundTile :: Bool
  -- , profileLinkColor :: String
  -- , profileSidebarBorderColor :: String
  -- , profileSidebarFillColor :: String
  -- , profileTextColor :: String
  -- , profileUseBackgroundImage :: Bool
  -- , profileImageURL :: String
  -- , profileImageURLHTTPS :: String
  -- , profileBannerURL :: String
  -- , defaultProfile :: Bool
  -- , defaultProfileImage :: Bool
  , following :: Maybe Bool
  -- , followRequestSent :: Maybe String
  , notifications :: Maybe Bool
  } deriving (Show, Generic)

type Users = Array User

data QuotedStatusPermalink = QuotedStatusPermalink
  { url :: String
  , expanded :: String
  , display :: String
  } deriving (Show, Generic)

data TwitStat = TwitStat
  { count :: Int
  } deriving (Show)

instance FromJSON Tweet
instance FromJSON Entities
instance FromJSON EUrl
instance FromJSON Hashtag
instance FromJSON Media
instance FromJSON QuotedStatus
instance FromJSON ExtendedEntities
instance FromJSON User
instance FromJSON QuotedStatusPermalink
