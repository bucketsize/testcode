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

monitor = do
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

main :: IO ()
main = do
  args <- getArgs
  route args
    where
      route ("cmd":q:_) = putStrLn (show (dispatch q))
      route ("mon":_) = monitor
      route _ = putStrLn "sysmon {cmd|mon} [{cmd}]"
