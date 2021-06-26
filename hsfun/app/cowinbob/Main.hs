{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

import Api
import ApiData
import AppData
import Control.Concurrent (forkIO, threadDelay)
import Control.Monad
import Control.Monad.IO.Class
import Data.Aeson (FromJSON, Object, ToJSON, decode, encode)
import qualified Data.ByteString.Lazy.Char8 as C
import Data.Char (toLower)
import Data.Foldable (toList)
import Data.List
import Data.List.Split
import qualified Data.Map.Strict as Map
import Data.Primitive.Array
import qualified Data.Text as T
import Data.Text (Text)
import Data.Text.Encoding
import Data.Time.Clock (UTCTime)
import GHC.Generics
import System.Environment
import Text.Printf (printf)
import Text.Regex.TDFA
import Utils

auth = AuthInfo "" "" "efgh"

searchSlotsCalendar :: SlotFilter -> IO [Slot]
searchSlotsCalendar sf = do
  st <- lookupState (state sf)
  case st of
    Just s -> do
      dt <- lookupDist s (district sf)
      case dt of
        Just d -> do
          cs <- getSlotsCalendarByDistrict
                    auth
                    (district_id (d :: District))
                    (searchDate sf)
          case cs of
            Just ac -> return (centersToSlots (centers (ac :: Centers)))
            Nothing -> return []
        Nothing -> return []
    Nothing -> return []

filterSlots :: SlotFilter -> [Slot] -> IO [FilteredSlot]
filterSlots slotFilter slots = do
  let fslots = filter (\slot -> (applyFilter slotFilter slot)) slots
  let cslots =
        map
          (\slot ->
             if (applyFilterCenter slotFilter slot)
               then FilteredSlot True slot
               else FilteredSlot False slot)
          fslots
  return cslots

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

lookupState :: String -> IO (Maybe State) -- TODO: IO (Maybe State)
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
             Just ((filter
                (\s -> (state_name (s :: State)) == state)
                (toList (states (ss :: States)))) !! 0)
         Nothing -> return Nothing)

lookupDist :: State -> String -> IO (Maybe District) -- TODO: IO (Maybe District)
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
              Just ((filter
                    (\s -> (district_name (s :: District)) == district)
                    (toList (districts (ss :: Districts)))) !! 0)
          Nothing -> return Nothing)

printSlots :: [FilteredSlot] -> IO ()
printSlots fslots = do
  let set1 = filter (\fslot -> ismatch (fslot :: FilteredSlot)) fslots
  let set2 = filter (\fslot -> not (ismatch (fslot :: FilteredSlot))) fslots
  putStrLn "[[--"
  mapM_ printSlot (set2 ++ set1)
  putStrLn "--]]"

mainOpts = do
  args <- getArgs
  case args of
    (state:district:fee:vax:age:date:cregx:itv:_) -> do
      let sf =
            SlotFilter
              { age = (read age :: Int)
              , feeType = fee
              , vaccineType = vax
              , searchDate = date
              , state = state
              , district = district
              , centers = cregx
              , interval = (read itv :: Int)
              }
      printf "<+> %s\n" (show sf)
      forever $ do
        (searchSlotsCalendar sf) >>= (filterSlots sf) >>= sendNotification >>=
          printSlots
        threadDelay (1000000 * (interval sf))
    _ ->
      putStrLn
        "cowinbob {state} {district} {fee} {vax} {age} {date} {centers:regx} {refreshinterval}"

sendNotification :: [FilteredSlot] -> IO [FilteredSlot]
sendNotification fslots = do
  let fslots' = filter (\fslot -> ismatch (fslot :: FilteredSlot)) fslots
  let msgs =
        (map
           (\fslot -> do
              let oslot = slot (fslot :: FilteredSlot)
              printf
                " %s, %s, %d, %d, %s, %d "
                (date (oslot :: Slot))
                (vaccine (oslot :: Slot))
                (min_age_limit (oslot :: Slot))
                (available_capacity_dose1 (oslot :: Slot))
                (name (oslot :: Slot))
                (pincode (oslot :: Slot)))
           fslots')
  let msg = intercalate "\n" msgs
  if msg == ""
    then return fslots
    else do
      sendToTGChat msg
      return fslots

main2 = do
  args <- getArgs
  case args of
    (sf:_) -> do
      print sf
      let filter = decode (C.pack sf) :: Maybe SlotFilter
      print filter
    _ -> return ()

main :: IO ()
main = mainOpts
