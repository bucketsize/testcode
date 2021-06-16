{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Api where

import ApiData
import AppData
import Data.Aeson (decode, encode)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Lazy.Char8 as L8
import Data.List
import Data.Time.Clock
import Data.Time.Format
import Data.Time.Format.ISO8601
import Data.Time.LocalTime
import Net
import Network.Connection
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Network.HTTP.Types.Header
import Network.HTTP.Types.Status
import System.IO

noSSLVerifyManager :: IO Manager
noSSLVerifyManager =
  let tlsSettings =
        TLSSettingsSimple
          { settingDisableCertificateValidation = True
          , settingDisableSession = False
          , settingUseServerName = True
          }
   in newManager $ mkManagerSettings tlsSettings Nothing

gTGPersonalBotUrl =
  "https://api.telegram.org/bot1772001607:AAGoFZyvBPN4DC2a7dPGrKATGsjmPT32sTU/sendMessage?chat_id=-1001292474235"

gHost = "https://cdn-api.co-vin.in/api"

gOTPUrl = gHost ++ "/v2/auth/public/generateOTP"

gOTPVUrl = gHost ++ "/v2/auth/public/confirmOTP"

gStatesUrl = gHost ++ "/v2/admin/location/states"

gDistrictsUrl = gHost ++ "/v2/admin/location/districts"

gSlotsUrl = gHost ++ "/v2/appointment/sessions/public/findByDistrict"

gSlotsCalendarUrl =
  gHost ++ "/v2/appointment/sessions/public/calendarByDistrict"

gDebug = True

logger :: FilePath -> IO (String -> IO ())
logger fn = do
  handle <- openFile fn AppendMode
  return
    (\s -> do
       utct <- getCurrentTime
       let ist = utcToLocalTime (TimeZone 330 False "IST") utct
       let time = iso8601Show ist
       hPutStr handle time
       hPutStr handle " - "
       hPutStrLn handle s)

logHttp :: Response L8.ByteString -> String
logHttp res =
  intercalate
    " - "
    [ (show (responseStatus res))
    , if (statusCode (responseStatus res) > 399)
        then (show (responseBody res))
        else "<redacted: all ok>"
    ]

sendToTGChat :: String -> IO ()
sendToTGChat s = do
  initReq <- parseRequest (gTGPersonalBotUrl ++ "&text=" ++ s)
  let req = initReq {method = "GET"}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  log <- logger "app.log"
  log (logHttp res)

requestOtp :: String -> IO (Maybe OtpRes)
requestOtp m = do
  initReq <- parseRequest gOTPUrl
  let req =
        initReq
          {method = "POST", requestBody = RequestBodyLBS $ encode (OtpReq m)}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  log <- logger "app.log"
  log (logHttp res)
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
  log <- logger "app.log"
  log (logHttp res)
  let obj = decode (responseBody res) :: Maybe OtpVRes
  return obj

getStates :: AuthInfo -> IO (Maybe States)
getStates auth = do
  initReq <- parseRequest gStatesUrl
  let req = initReq {method = "GET"}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  log <- logger "app.log"
  log (logHttp res)
  let obj = decode (responseBody res) :: Maybe States
  return obj

getDistricts :: AuthInfo -> Int -> IO (Maybe Districts)
getDistricts auth stateId = do
  initReq <- parseRequest (gDistrictsUrl ++ "/" ++ (show stateId))
  let req = initReq {method = "GET"}
  manager <- noSSLVerifyManager
  res <- httpLbs req manager
  log <- logger "app.log"
  log (logHttp res)
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
  log <- logger "app.log"
  log (logHttp res)
  let obj = decode (responseBody res) :: Maybe Slots
  return obj

getSlotsCalendarByDistrict :: AuthInfo -> Int -> String -> IO (Maybe Centers)
getSlotsCalendarByDistrict auth distId dateStr = do
  initReq <-
    parseRequest
      (gSlotsCalendarUrl ++
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
  log <- logger "app.log"
  log (logHttp res)
  let obj = decode (responseBody res) :: Maybe Centers
  return obj
