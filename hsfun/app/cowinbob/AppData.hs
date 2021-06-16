{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

module AppData where

import ApiData
import Data.Aeson (FromJSON)
import GHC.Generics
import Text.Printf (printf)
import Text.Regex.TDFA
import Utils

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
    , state :: String
    , district :: String
    , centers :: String
    , interval :: Int
    }
  deriving (Show, Generic)

instance FromJSON SlotFilter

class SlotPrinter t where
  printSlot :: t -> IO ()

data FilteredSlot =
  FilteredSlot
    { ismatch :: Bool
    , slot :: Slot
    }

instance SlotPrinter FilteredSlot where
  printSlot fslot = do
    let oslot = slot fslot
    let line =
          printf
            "%s %s, %s, Age:%d, Fee:%s, %s, N:%d, %d, %d, %s, %d, %s, %s"
            (if (ismatch (fslot :: FilteredSlot))
               then "*"
               else " ")
            (date (oslot :: Slot))
            (vaccine (oslot :: Slot))
            (min_age_limit (oslot :: Slot))
            (fee_type (oslot :: Slot))
            (fee (oslot :: Slot))
            (available_capacity (oslot :: Slot))
            (available_capacity_dose1 (oslot :: Slot))
            (available_capacity_dose2 (oslot :: Slot))
            (name (oslot :: Slot))
            (pincode (oslot :: Slot))
            (block_name (oslot :: Slot))
            (address (oslot :: Slot))
    putStrLn (take 140 line)

class Filterable t where
  applyFilter :: SlotFilter -> t -> Bool
  applyFilterCenter :: SlotFilter -> t -> Bool

instance Filterable Slot where
  applyFilter slotFilter slot = dose1C && (vaxC && ageC && feeC)
    where
      dose1C = (available_capacity_dose1 (slot :: Slot)) > 0
      vaxC =
        ((vaccineType slotFilter) == "Any") ||
        ((vaccine (slot :: Slot)) == (vaccineType slotFilter))
      ageC =
        ((age slotFilter) == -1) ||
        ((min_age_limit (slot :: Slot)) == (age slotFilter))
      feeC =
        ((feeType slotFilter) == "Any") ||
        ((fee_type (slot :: Slot)) == (feeType slotFilter))
  applyFilterCenter slotFilter slot = centerC
    where
      centerC =
        (centers (slotFilter :: SlotFilter)) == "" ||
        toLowerString (name (slot :: Slot)) =~
        toLowerString (centers (slotFilter :: SlotFilter))
