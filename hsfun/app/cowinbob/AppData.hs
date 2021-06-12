{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

module AppData where

data AuthInfo =
  AuthInfo
    { username :: String
    , password :: String
    , authTokn :: String
    }

data SlotFilter =
  SlotFilter
    { age :: Int
    , feeType :: String
    , vaccineType :: String
    , searchDate :: String
    }
