{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

module TwitUser where

import Data.Primitive.Array
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON, Object)

-- data User = User
--     { id :: Maybe Int
--     , idStr :: Maybe String
--     , name :: Maybe String
--     , screen_name :: Maybe String
--     , location :: Maybe String
--     , description :: Maybe String
--     , url :: Maybe String
--     , entities :: Maybe Entities
--     , protected :: Maybe Bool
--     , followers_count :: Maybe Int
--     , friends_count :: Maybe Int
--     , listed_count :: Maybe Int
--     , created_at :: Maybe String
--     , favourites_count :: Maybe Int
--     -- , utcOffset :: Maybe ()
--     -- , timeZone :: Maybe ()
--     -- , geoEnabled :: Maybe Bool
--     , verified :: Maybe Bool
--     -- , statusesCount :: Maybe Int
--     , lang :: Maybe String
--     , status :: Maybe Status
--     -- , contributorsEnabled :: Maybe Bool
--     -- , isTranslator :: Maybe Bool
--     -- , isTranslationEnabled :: Maybe Bool
--     -- , profileBackgroundColor :: Maybe String
--     -- , profileBackgroundImageURL :: Maybe String
--     -- , profileBackgroundImageURLHTTPS :: Maybe String
--     -- , profileBackgroundTile :: Maybe Bool
--     -- , profileImageURL :: Maybe String
--     -- , profileImageURLHTTPS :: Maybe String
--     -- , profileBannerURL :: Maybe String
--     -- , profileLinkColor :: Maybe String
--     -- , profileSidebarBorderColor :: Maybe String
--     -- , profileSidebarFillColor :: Maybe String
--     -- , profileTextColor :: Maybe String
--     -- , profileUseBackgroundImage :: Maybe Bool
--     -- , hasExtendedProfile :: Maybe Bool
--     -- , defaultProfile :: Maybe Bool
--     -- , defaultProfileImage :: Maybe Bool
--     , following :: Maybe Bool
--     -- , followRequestSent :: Maybe Bool
--     , notifications :: Maybe Bool
--     , translator_type :: Maybe String
--     } deriving (Show, Generic)

-- data Entities = Entities
--     { url :: Maybe Description
--     , description :: Maybe Description
--     } deriving (Show, Generic)

-- data Description = Description
--     { urls :: Maybe (Array URL)
--     } deriving (Show, Generic)

-- data URL = URL
--     { url :: Maybe String
--     , expanded_URL :: Maybe String
--     , display_URL :: Maybe String
--     , indices :: Maybe (Array Int)
--     } deriving (Show, Generic)

-- data Status = Status
--     { created_at :: Maybe String
--     , id :: Maybe Float
--     -- , idStr :: Maybe String
--     , text :: Maybe String
--     , truncated :: Maybe Bool
--     , entities :: Maybe StatusEntities
--     , source :: Maybe String
--     -- , inReplyToStatusID :: Maybe ()
--     -- , inReplyToStatusIDStr :: Maybe ()
--     -- , inReplyToUserID :: Maybe ()
--     -- , inReplyToUserIDStr :: Maybe ()
--     -- , inReplyToScreenName :: Maybe ()
--     , geo :: Maybe ()
--     , coordinates :: Maybe ()
--     , place :: Maybe ()
--     , contributors :: Maybe ()
--     -- , isQuoteStatus :: Maybe Bool
--     -- , retweetCount :: Maybe Int
--     -- , favoriteCount :: Maybe Int
--     , favorited :: Maybe Bool
--     , retweeted :: Maybe Bool
--     -- , possiblySensitive :: Maybe Bool
--     , lang :: Maybe String
--     } deriving (Show, Generic)

-- data StatusEntities = StatusEntities
--     { hashtags :: Maybe (Array String)
--     , symbols :: Maybe (Array String)
--     , user_mentions :: Maybe (Array String)
--     , urls :: Maybe (Array URL)
--     } deriving (Show, Generic)

-- instance FromJSON User
-- instance FromJSON Entities
-- instance FromJSON Description
-- instance FromJSON URL
-- instance FromJSON Status
-- instance FromJSON StatusEntities

