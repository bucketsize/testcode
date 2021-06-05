{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

import Data.ByteString (ByteString)
import Data.Primitive.Array
import Network.HTTP.Conduit
import Web.Authenticate.OAuth
import Data.Aeson (FromJSON, ToJSON, Object, encode, decode)
import Data.Time.Clock (UTCTime)
import Data.Text (Text)
import GHC.Generics
import qualified Data.ByteString.Lazy.Char8 as L8
import qualified Data.ByteString.Char8 as C8
import System.Environment
import Network.Connection
import Conduit
import qualified Data.Text as T
import Data.Text.Encoding
import Data.List.Split
import Data.List
import qualified Data.Map.Strict as Map
import Net

data AuthInfo = AuthInfo
  { username :: String,
    password :: String,
    authTokn :: String
  } deriving (Show, Generic)


data Slot = Slot
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
    } deriving (Show, Generic)

data Slots = Slots
  { sessions :: Array Slot } deriving (Show, Generic)

data OtpReq = OtpReq
  { mobile :: String } deriving (Show, Generic)

data OtpRes = OtpRes
  { txnId :: String } deriving (Show, Generic)

data OtpVReq = OtpVReq
  { txnId :: String,
    otp :: String
  } deriving (Show, Generic)

data OtpVRes = OtpVRes
  { token :: String
  } deriving (Show, Generic)

data State = State
  { state_id :: Int,
    state_name :: String
  } deriving (Show, Generic)

data States = States
  { states :: Array State,
    ttl :: Int
  } deriving (Show, Generic)

data District = District
  { 
    district_id :: Int,
    district_name :: String
  } deriving (Show, Generic)

data Districts = Districts
  { districts :: Array District,
    ttl :: Int
  } deriving (Show, Generic)

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
  let tlsSettings = TLSSettingsSimple {
      settingDisableCertificateValidation = True
      , settingDisableSession=False
      , settingUseServerName=True
      }
   in newManager $ mkManagerSettings tlsSettings Nothing


gHost = "https://cdn-api.co-vin.in/api"
gOTPUrl = gHost ++ "/v2/auth/public/generateOTP"
gOTPVUrl = gHost ++ "/v2/auth/public/confirmOTP"
gStatesUrl = gHost ++ "/v2/admin/location/states"
gDistrictsUrl = gHost ++ "/v2/admin/location/districts"
gSlotsUrl = gHost ++ "/v2/appointment/sessions/public/findByDistrict"

logHttp res = do
  putStrLn "--{--"
  putStrLn $ show (responseStatus res)
  L8.putStrLn $ responseBody res
  putStrLn "--}--"
  

requestOtp  :: String -> IO (Maybe OtpRes)
requestOtp m = do
  initReq <- parseRequest gOTPUrl
  let req = initReq
            { method = "POST",
              requestBody = RequestBodyLBS $ encode (OtpReq m)
            }
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe OtpRes
  return obj
  
validateOtp :: String -> String -> IO (Maybe OtpVRes)
validateOtp txnId otp = do
  initReq <- parseRequest gOTPVUrl
  let req = initReq
            { method = "POST",
              requestBody = RequestBodyLBS $ encode (OtpVReq txnId otp)
            }
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe OtpVRes
  return obj
  
getStates :: AuthInfo -> IO (Maybe States)
getStates auth = do 
  initReq <- parseRequest gStatesUrl
  let req = initReq
            { method = "GET"
            }
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe States
  return obj
  
getDistricts :: AuthInfo -> Int -> IO (Maybe Districts)
getDistricts auth stateId = do 
  initReq <- parseRequest (gDistrictsUrl ++ "/" ++ (show stateId))
  let req = initReq
            { method = "GET"
            }
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  logHttp res
  let obj = decode (responseBody res) :: Maybe Districts
  return obj

getSlotsByDistrict :: AuthInfo -> Int -> String -> IO (Maybe Slots)
getSlotsByDistrict auth distId dateStr = do
  initReq <- parseRequest (gSlotsUrl ++
                           "?district_id=" ++ (show distId) ++
                           "&date=" ++ (show dateStr)
                          )
  let req = initReq
            { method = "GET",
              requestHeaders = [packHeader ("Authorization", "Bearer "++(authTokn (auth :: AuthInfo)))]
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

main3 = do
  let auth = AuthInfo "" "" "efgh"

  states <- getStates auth
  putStrLn $ "done " ++ (show states)
  
  dists <- getDistricts auth 16
  putStrLn $ "done " ++ (show dists)
  
  mslots <- getSlotsByDistrict auth 294 "02-06-2021"

  mslots >>= (\aslot -> do
                 aslot >>= (\slot -> do
                               return slot)
                 return aslot)

  putStrLn $ "done "
  
