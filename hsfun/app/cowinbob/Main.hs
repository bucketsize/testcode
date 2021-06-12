{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

import Data.Aeson (FromJSON, Object, ToJSON, decode, encode)
import Data.Foldable (toList)
import Data.Primitive.Array
import GHC.Generics

import Data.List
import Data.List.Split
import qualified Data.Map.Strict as Map
import qualified Data.Text as T
import Data.Time.Clock (UTCTime)

import Api
import ApiData
import AppData
import Data.Text (Text)
import Data.Text.Encoding
import System.Environment
import Text.Printf (printf)

import Utils

searchSlots :: String -> String -> String -> IO ()
searchSlots stn dtn date = do
  let auth = AuthInfo "" "" "efgh"
  st <- lookupState stn
  dt <- lookupDist st dtn
  mslots <- getSlotsByDistrict auth (district_id (dt :: District)) date
  case mslots of
    Just aslot -> do
      displaySlots (SlotFilter 18 "Paid" "COVISHIELD" date) aslot
      displaySlots (SlotFilter 45 "Paid" "COVISHIELD" date) aslot
    Nothing -> do
      mapM_ print []

applyFilter1 :: SlotFilter -> Slot -> Bool
applyFilter1 slotFilter slot = b1 && (c1 && c2 && c3)
  where
    b1 = (available_capacity_dose1 (slot :: Slot)) > 0
    c1 = (vaccine (slot :: Slot)) == (vaccineType slotFilter)
    c2 = (min_age_limit (slot :: Slot)) == (age slotFilter)
    c3 = (fee_type (slot :: Slot)) == (feeType slotFilter)

locToGmapUrl :: Float -> Float -> String
locToGmapUrl lat lng = url
  where
    url =
      "https://www.google.com/maps/@" ++
      (show lat) ++ "," ++ (show lng) ++ ",6z"

displaySlots :: SlotFilter -> Slots -> IO ()
displaySlots slotFilter slots = do
  mapM_
    (\slot -> do
       if (applyFilter1 slotFilter slot)
         then printf
                "%s, %s, (age: %d), (%s: %s), (slots: %d, dose1: %d), %s, %d, (%s)\n"
                (date (slot :: Slot))
                (vaccine (slot :: Slot))
                (min_age_limit (slot :: Slot))
                (fee_type (slot :: Slot))
                (fee (slot :: Slot))
                (available_capacity (slot :: Slot))
                (available_capacity_dose1 (slot :: Slot))
                (name (slot :: Slot))
                (pincode (slot :: Slot))
                (address (slot :: Slot))
         else return ())
    (sessions (slots :: Slots))

lookupState :: String -> IO State -- TODO: IO (Maybe State)
lookupState state = do
  let auth = AuthInfo "" "" "efgh"
  cachd <- fileExists "states.obj"
  let mms =
        if cachd
          then (readFile "states.obj") >>=
               (\x -> return (Just (read x :: States)))
          else (getStates auth) >>=
               (\x -> do
                  case x of
                    Just y -> dumpTo "states.obj" (show y)
                    Nothing -> return ()
                  return x)
  mms >>=
    (\ms -> do
       case ms of
         Just ss -> do
           return $
             (filter
                (\s -> (state_name (s :: State)) == state)
                (toList (states (ss :: States)))) !!
             0
         Nothing -> return State {})

lookupDist :: State -> String -> IO District -- TODO: IO (Maybe District)
lookupDist state district = do
  let auth = AuthInfo "" "" "efgh"
  cachd <- fileExists "distrs.obj"
  let mms =
        if cachd
          then (readFile "distrs.obj") >>=
               (\x -> return (Just (read x :: Districts)))
          else (getDistricts auth (state_id (state :: State))) >>=
               (\x -> do
                  case x of
                    Just y -> dumpTo "distrs.obj" (show y)
                    Nothing -> return ()
                  return x)
  mms >>=
    (\ms -> do
       case ms of
         Just ss -> do
           return $
             (filter
                (\s -> (district_name (s :: District)) == district)
                (toList (districts (ss :: Districts)))) !!
             0
         Nothing -> return District {})

mainOpts = do
  args <- getArgs
  case args of
    (stn:dtn:date:_) -> do
      searchSlots stn dtn date
    _ -> putStrLn "cowinbob {state} {district} {date}"

main1 = do
  st <- lookupState "Karnataka"
  dt <- lookupDist st "BBMP"
  print st
  print dt

main :: IO ()
main = mainOpts
