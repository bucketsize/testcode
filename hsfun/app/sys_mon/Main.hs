{-# LANGUAGE OverloadedStrings #-}

import System.Environment (getArgs)
import System.Time.Extra
import Control.Monad
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar (newEmptyMVar, takeMVar, putMVar)

import SysFns
import SysCtl

cpuUsageAg :: Float -> Float -> IO ()
cpuUsageAg t z = do
  (t1, z1, c) <- cpuUsage t z
  putStrLn("cpu: " ++ show c)
  threadDelay 1000000
  cpuUsageAg t1 z1


main :: IO ()
main = main2

main1 = do
  forkIO (do
    forever (do
        m <- memUsage
        putStrLn("mem: " ++ show m)
        threadDelay 1000000
      )
    )

  forkIO (do
    cpuUsageAg 0.0 0.0
    )

  putStrLn("Started, waiting for killSig ...")
  forever (do
    threadDelay (1000000*60)
    )

main2 = do
  args <- getArgs
  case args of
    [a, q] -> do
      if a == "fun" then do
        let s = dispatch q
        case s of
          Just x  -> putStrLn("") -- FIXME
          Nothing -> putStrLn("")
      else
        putStrLn("")
    _ -> putStrLn("")

