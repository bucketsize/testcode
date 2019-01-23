{-# LANGUAGE OverloadedStrings #-}

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as L8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Simple


main :: IO ()
main = do
    let request =
            setRequestPath "/get"
                (setRequestHost "httpbin.org"
                    defaultRequest)
    response <- httpJSON request

    putStrLn ("status: " ++ show (getResponseStatusCode response))
    putStrLn ("content-type: " ++ show (getResponseHeader "Content-Type" response))
    L8.putStrLn (Yaml.encode ((getResponseBody response)::Value))
