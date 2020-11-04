import SysFns
import System.Time.Extra
import Control.Monad
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar (newEmptyMVar, takeMVar, putMVar)


cpuUsageAg :: Float -> Float -> IO ()
cpuUsageAg t z = do
  (t1, z1, c) <- cpuUsage t z
  putStrLn("cpu: " ++ show c)
  threadDelay 1000000
  cpuUsageAg t1 z1


main :: IO ()
main = do
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
