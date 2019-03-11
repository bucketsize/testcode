{-# LANGUAGE OverloadedStrings #-}

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as Char8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Simple
import System.Environment (getArgs)


main :: IO ()
main = do
	args <- getArgs
	case args of
		[method, url] -> do
            httpGet method url

httpGet = do
    let request =
            setRequestPath "/get"
            $ setRequestHost "httpbin.org"
            $ defaultRequest
    response <- httpJSON request

    putStrLn ("status: " ++ show (getResponseStatusCode response))
    putStrLn ("content-type: " ++ show (getResponseHeader "Content-Type" response))

    Char8.putStrLn (Yaml.encode ((getResponseBody response)::Value))
