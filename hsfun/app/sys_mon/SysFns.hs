module SysFns where

import Text.Regex.TDFA
import System.Time.Extra
import Control.Monad
import Control.Concurrent (forkIO, threadDelay)
import Utils

procStat :: IO [Float]
procStat = do
  cpus <- readFileLns "/proc/stat"
  let cpu =  map (\s -> read s :: Float) (getAllTextMatches((head cpus) =~ "[0-9]+") :: [String])
  return cpu

cpuUsage :: Float -> Float -> IO (Float, Float, Float)
cpuUsage ott otz = do
  cts <- procStat
  let tt = sum cts
  let tz = last (take 4 cts)
  let dt = (tt - ott)
  let dz = (tz - otz)
  let cu = (1-dz/dt)
  return (tt, tz, cu)

memUsage :: IO Float
memUsage = do
  s <- readFile "/proc/meminfo"
  let mts = s =~ "MemTotal:[[:blank:]]+([0-9]+)" :: String
  let mfs = s =~ "MemFree:[[:blank:]]+([0-9]+)" ::String
  let mt = mts =~ "[[:digit:]]+" ::String
  let mf = mfs =~ "[[:digit:]]+" ::String
  return (1-(read mf::Float)/(read mt::Float))


