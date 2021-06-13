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

searchSlots :: SlotFilter -> IO ()
searchSlots slotFilter = do
  let auth = AuthInfo "" "" "efgh"
  st <- lookupState (state slotFilter)
  dt <- lookupDist st (district slotFilter)
  mslots <-
    getSlotsByDistrict
      auth
      (district_id (dt :: District))
      (searchDate slotFilter)
  case mslots of
    Just aslot -> do
      displaySlots slotFilter aslot
    Nothing -> putStrLn "no data"

searchSlotsCalendar :: SlotFilter -> IO ()
searchSlotsCalendar slotFilter = do
  let auth = AuthInfo "" "" "efgh"
  st <- lookupState (state slotFilter)
  dt <- lookupDist st (district slotFilter)
  mcenters <-
    getSlotsCalendarByDistrict
      auth
      (district_id (dt :: District))
      (searchDate slotFilter)
  case mcenters of
    Just acenters -> do
      let aslots = Slots {sessions = centersToSlots (centers acenters)}
      displaySlots slotFilter aslots
    Nothing -> putStrLn "no data"

class Filterable t where
  applyFilter :: SlotFilter -> t -> Bool

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
       if (applyFilter slotFilter slot)
         then printSlot slot
         else return ())
    (sessions (slots :: Slots))

centersToSlots :: [Center] -> [Slot]
centersToSlots cs = concat $ map (\c -> centerToSlots c) cs

centerToSlots :: Center -> [Slot]
centerToSlots c =
  map
    (\s ->
       Slot
         (center_id (c :: Center))
         (name (c :: Center))
         (address (c :: Center))
         (state_name (c :: Center))
         (district_name (c :: Center))
         (block_name (c :: Center))
         (pincode (c :: Center))
         (lat (c :: Center))
         (long (c :: Center))
         ("from") -- (c :: Center)
         ("to") -- (c :: Center)
         (fee_type (c :: Center))
         ("?") --fee :: Session
         ("?") -- session_id :: Session
         (date (s :: Session))
         (available_capacity (s :: Session))
         (available_capacity_dose1 (s :: Session))
         (available_capacity_dose2 (s :: Session))
         (min_age_limit (s :: Session))
         (vaccine (s :: Session))
         (slots (s :: Session)))
    (sessions (c :: Center))

class SlotPrinter t where
  printSlot :: t -> IO ()

instance SlotPrinter Slot where
  printSlot slot = do
    printf
      "%s, %s, Age:%d, Fee:%s, %s, N:%d, %d, %d, %s, %d, %s, %s\n"
      (date (slot :: Slot))
      (vaccine (slot :: Slot))
      (min_age_limit (slot :: Slot))
      (fee_type (slot :: Slot))
      (fee (slot :: Slot))
      (available_capacity (slot :: Slot))
      (available_capacity_dose1 (slot :: Slot))
      (available_capacity_dose2 (slot :: Slot))
      (name (slot :: Slot))
      (pincode (slot :: Slot))
      (block_name (slot :: Slot))
      (address (slot :: Slot))

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
    (state:district:fee:vax:age:date:_) -> do
      let filter = (SlotFilter (read age :: Int) fee vax date state district)
      printf "using filter=> %s" (show filter)
      searchSlotsCalendar filter
    _ -> putStrLn "cowinbob {state} {district} {fee} {vax} {age} {date}"

main1 = do
  st <- lookupState "Karnataka"
  dt <- lookupDist st "BBMP"
  print st
  print dt

main :: IO ()
main = mainOpts
