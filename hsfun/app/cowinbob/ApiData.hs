{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

--
-- created with https://app.quicktype.io/ --
--
module ApiData where

import Data.Aeson (FromJSON, Object, ToJSON)
import Data.Primitive.Array
import GHC.Generics

data Slot =
  Slot
    { center_id :: Int
    , name :: String
    , address :: String
    , state_name :: String
    , district_name :: String
    , block_name :: String
    , pincode :: Int
    , lat :: Float
    , long :: Float
    , from :: String
    , to :: String
    , fee_type :: String
    , fee :: String
    , session_id :: String
    , date :: String
    , available_capacity :: Int
    , available_capacity_dose1 :: Int
    , available_capacity_dose2 :: Int
    , min_age_limit :: Int
    , vaccine :: String
    , slots :: [String]
    }
  deriving (Show, Generic)

data Slots =
  Slots
    { sessions :: [Slot]
    }
  deriving (Show, Generic)

data OtpReq =
  OtpReq
    { mobile :: String
    }
  deriving (Show, Generic)

data OtpRes =
  OtpRes
    { txnId :: String
    }
  deriving (Show, Generic)

data OtpVReq =
  OtpVReq
    { txnId :: String
    , otp :: String
    }
  deriving (Show, Generic)

data OtpVRes =
  OtpVRes
    { token :: String
    }
  deriving (Show, Generic)

data State =
  State
    { state_id :: Int
    , state_name :: String
    }
  deriving (Show, Read, Generic)

data States =
  States
    { states :: [State]
    , ttl :: Int
    }
  deriving (Show, Read, Generic)

data District =
  District
    { district_id :: Int
    , district_name :: String
    }
  deriving (Show, Read, Generic)

data Districts =
  Districts
    { districts :: [District]
    , ttl :: Int
    }
  deriving (Show, Read, Generic)

data Centers =
  Centers
    { centers :: [Center]
    }
  deriving (Show, Generic)

data Center =
  Center
    { center_id :: Int
    , name :: String
    , address :: String
    , state_name :: String
    , district_name :: String
    , block_name :: String
    , pincode :: Int
    , lat :: Float
    , long :: Float
    , from :: String
    , to :: String
    , fee_type :: String
    , vaccine_fees :: Maybe [VaccineFee]
    , sessions :: [Session]
    }
  deriving (Show, Generic)

data Session =
  Session
    { session_id :: String
    , date :: String
    , available_capacity :: Int
    , available_capacity_dose1 :: Int
    , available_capacity_dose2 :: Int
    , min_age_limit :: Int
    , vaccine :: String
    , slots :: [String]
    }
  deriving (Show, Generic)

data VaccineFee =
  VaccineFee
    { vaccine :: String
    , fee :: String
    }
  deriving (Show, Generic)

instance ToJSON OtpReq

instance ToJSON OtpVReq

instance FromJSON OtpRes

instance FromJSON OtpVRes

instance FromJSON State

instance FromJSON States

instance FromJSON District

instance FromJSON Districts

instance FromJSON Slot

instance FromJSON Slots

instance FromJSON Center

instance FromJSON Centers

instance FromJSON Session

instance FromJSON VaccineFee
