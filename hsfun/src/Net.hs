{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Net where

import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Base64 as B64
import Data.CaseInsensitive (CI)
import qualified Data.CaseInsensitive as CI

basicAuth k v =
  "Basic " ++ (C8.unpack . B64.encode . C8.pack) (k ++ ":" ++ v)

packHeader :: (String, String) ->  (CI C8.ByteString, C8.ByteString)
packHeader (k, v) = (CI.mk (C8.pack k), C8.pack v)

