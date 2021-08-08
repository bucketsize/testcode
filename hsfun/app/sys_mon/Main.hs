{-# LANGUAGE OverloadedStrings #-}

import System.Environment (getArgs)
import System.Time.Extra
import Control.Monad
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar (newEmptyMVar, takeMVar, putMVar)

import SysFns
import SysCtl

import Control.Monad.Coroutine (Coroutine, pogoStick, bounce)
import Control.Monad.Coroutine.SuspensionFunctors
import Control.Monad.Trans.Class (lift)
import Control.Monad.IO.Class (liftIO)

crCpuUsage :: Coroutine (Yield Float) IO ()
crCpuUsage = do
  cputz 0.0 0.0
  return ()
  where
    cputz t z = do
      (tn,zn,c) <- lift (cpuUsage t z)
      yield c
      cputz tn zn

runCR :: Show x => Coroutine (Yield x) IO r -> IO r
runCR cr =
  pogoStick
  (\(Yield x cont) -> do
      lift (print x)
      lift $ threadDelay 500000
      cont
  )
  (cr)

runCR2 :: Show x => Coroutine (Yield x) IO r -> IO r
runCR2 cr = do
  c1 <- liftIO $ bounce
    (\(Yield x cont) -> do
        lift (print x)
        cont
    )
    (cr)
  return ()

monitor = do
  liftIO (runCR crCpuUsage)

main :: IO ()
main = do
  args <- getArgs
  route args
    where
      route ("cmd":q:_) = do
        r <- dispatch q
        case r of
          Just s -> putStrLn s
          Nothing -> putStrLn ""
      route ("mon":_) = monitor
      route _ = putStrLn "sysmon {cmd|mon} [{cmd}]"
