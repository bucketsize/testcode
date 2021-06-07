{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

import Conduit
import Data.Aeson (FromJSON, Object, ToJSON, decode, encode)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Lazy.Char8 as L8
import Data.List
import Data.List.Split
import qualified Data.Map.Strict as Map
import Data.Primitive.Array
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Encoding
import Data.Time.Clock (UTCTime)
import GHC.Generics
import Net
import Network.Connection
import Network.HTTP.Conduit
import System.Environment
import Text.Printf (printf)
import Web.Authenticate.OAuth

data AuthInfo =
  AuthInfo
    { username :: String
    , password :: String
    , authTokn :: String
    }
  deriving (Show, Generic)

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
    , slots :: Array String
    }
  deriving (Show, Generic)

data Slots =
  Slots
    { sessions :: Array Slot
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
  deriving (Show, Generic)

data States =
  States
    { states :: Array State
    , ttl :: Int
    }
  deriving (Show, Generic)

data District =
  District
    { district_id :: Int
    , district_name :: String
    }
  deriving (Show, Generic)

data Districts =
  Districts
    { districts :: Array District
    , ttl :: Int
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

noSSLVerifyManager :: IO Manager
noSSLVerifyManager =
  let tlsSettings =
        TLSSettingsSimple
          { settingDisableCertificateValidation = True
          , settingDisableSession = False
          , settingUseServerName = True
          }
   in newManager $ mkManagerSettings tlsSettings Nothing

gHost = "https://cdn-api.co-vin.in/api"

gOTPUrl = gHost ++ "/v2/auth/public/generateOTP"

gOTPVUrl = gHost ++ "/v2/auth/public/confirmOTP"

gStatesUrl = gHost ++ "/v2/admin/location/states"

gDistrictsUrl = gHost ++ "/v2/admin/location/districts"

gSlotsUrl = gHost ++ "/v2/appointment/sessions/public/findByDistrict"

gDebug = False

logHttp :: Response L8.ByteString -> IO ()
logHttp res = do
  if gDebug
    then (putStrLn (show (responseStatus res))) >>
         (L8.putStrLn (responseBody res))
    else putStrLn ""

requestOtp :: String -> IO (Maybe OtpRes)
requestOtp m = do
  initReq <- parseRequest gOTPUrl
  let req =
        initReq
          {method = "POST", requestBody = RequestBodyLBS $ encode (OtpReq m)}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe OtpRes
  return obj

validateOtp :: String -> String -> IO (Maybe OtpVRes)
validateOtp txnId otp = do
  initReq <- parseRequest gOTPVUrl
  let req =
        initReq
          { method = "POST"
          , requestBody = RequestBodyLBS $ encode (OtpVReq txnId otp)
          }
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe OtpVRes
  return obj

getStates :: AuthInfo -> IO (Maybe States)
getStates auth = do
  initReq <- parseRequest gStatesUrl
  let req = initReq {method = "GET"}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe States
  return obj

getDistricts :: AuthInfo -> Int -> IO (Maybe Districts)
getDistricts auth stateId = do
  initReq <- parseRequest (gDistrictsUrl ++ "/" ++ (show stateId))
  let req = initReq {method = "GET"}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe Districts
  return obj

getSlotsByDistrict :: AuthInfo -> Int -> String -> IO (Maybe Slots)
getSlotsByDistrict auth distId dateStr = do
  initReq <-
    parseRequest
      (gSlotsUrl ++
       "?district_id=" ++ (show distId) ++ "&date=" ++ (show dateStr))
  let req =
        initReq
          { method = "GET"
          , requestHeaders =
              [ packHeader
                  ("Authorization", "Bearer " ++ (authTokn (auth :: AuthInfo)))
              ]
          }
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe Slots
  return obj

main :: IO ()
main = main3

main1 = do
  otpRes <- requestOtp "9916590238"
  case otpRes of
    Just o1 -> do
      putStrLn "Enter OTP: "
      otp <- getLine
      otpVRes <- validateOtp (txnId (o1 :: OtpRes)) otp
      case otpVRes of
        Just o2 -> do
          let auth = AuthInfo "" "" (token ((o2 :: OtpVRes)))
          states <- getStates auth
          putStrLn "done"
        Nothing -> print "validateOtp failed"
      putStrLn "done"
    Nothing -> print "requestOtp failed"

main2 = do
  otpVRes <- validateOtp "abcd" "123456"
  putStrLn $ "done" ++ (show otpVRes)

main4 = do
  let auth = AuthInfo "" "" "efgh"
  states <- getStates auth
  --putStrLn $ "done " ++ (show states)
  dists <- getDistricts auth 16
  --putStrLn $ "done " ++ (show dists)
  putStrLn "done"

main3 = do
  mapM_
    searchSlots
    [ y ++ "-06-2021"
    | x <- [7 .. 12]
    , let y =
            if x < 10
              then ("0" ++ (show x))
              else (show x)
    ]

searchSlots :: String -> IO ()
searchSlots date = do
  let auth = AuthInfo "" "" "efgh"
  mslots <- getSlotsByDistrict auth 294 date
  case mslots of
    Just aslot -> do
      displaySlots (SlotFilter 18 "Paid" "COVISHIELD" date) aslot
      displaySlots (SlotFilter 45 "Paid" "COVISHIELD" date) aslot
      --displaySlots (SlotFilter 18 "Free" "COVISHIELD") aslot
      --displaySlots (SlotFilter 45 "Free" "COVISHIELD") aslot
    Nothing -> do
      mapM_ print []

data SlotFilter =
  SlotFilter
    { age :: Int
    , feeType :: String
    , vaccineType :: String
    , searchDate :: String
    }

applyFilter1 :: SlotFilter -> Slot -> Bool
applyFilter1 slotFilter slot = b1 && (c1 && c2 && c3)
  where
    b1 = (available_capacity_dose1 slot) > 0
    c1 = (vaccine slot) == (vaccineType slotFilter)
    c2 = (min_age_limit slot) == (age slotFilter)
    c3 = (fee_type slot) == (feeType slotFilter)

locToGmapUrl :: Float -> Float -> String
locToGmapUrl lat lng = url
  where
    url =
      "https://www.google.com/maps/@" ++
      (show lat) ++ "," ++ (show lng) ++ ",6z"

displaySlots :: SlotFilter -> Slots -> IO ()
displaySlots slotFilter slots = do
  (printf
     "%s | %d -> %s -> %s\n"
     (searchDate slotFilter)
     (age slotFilter)
     (feeType slotFilter)
     (vaccineType slotFilter))
  mapM_
    (\slot -> do
       if (applyFilter1 slotFilter slot)
         then printf
                "%s | %s, {age: %d}, (%s, %s), [slots: %d, dose1: %d], %s, %d, %s\n"
                (date slot)
                (vaccine slot)
                (min_age_limit slot)
                (fee_type slot)
                (fee slot)
                (available_capacity slot)
                (available_capacity_dose1 slot)
                (name slot)
                (pincode slot)
                ""
                --(locToGmapUrl (lat slot) (long slot))
                --(address slot)
         else printf "")
    (sessions slots)
