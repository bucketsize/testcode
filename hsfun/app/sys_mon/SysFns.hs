module SysFns where

import Text.Regex.TDFA ((=~), getAllTextMatches)
import Text.Printf (printf)
import System.Time.Extra
import Control.Monad
import Control.Exception (try, SomeException)
import Control.Concurrent (forkIO, threadDelay)
import Data.List.Extra (trim)
import Utils (readFileLns, fileExists)

procStat :: IO [Float]
procStat = do
  cpus <- readFileLns "/proc/stat"
  let cpu =
        map
         (\s -> read s :: Float)
         (getAllTextMatches((head cpus) =~ "[0-9]+") :: [String])
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

hwTemp :: IO [(String, Float)]
hwTemp = do
  let ft = "/sys/class/hwmon/hwmon%d/temp%d_label"
      vt = "/sys/class/hwmon/hwmon%d/temp%d_input"
  tsource <- filterM
        (\(ts, tv) -> do
            f <- (fileExists ts)
            return f)
        [((printf ft x y), (printf vt x y))
          | x <- [0..7]::[Int], y <-[0..16]::[Int]]
  mapM_ (\(k, v) -> printf "tsource: %s -> %s\n" k v) tsource
  mapM
    (\(s, t) -> do
      tl <- readFile s
      tv <- readFile t
      return (trim tl, (read tv :: Float)/1000.0))
    tsource

tLabels = ["Tdie"]

cpuTemp :: IO Float
cpuTemp = do -- TODO: use pattern matching
  hwts <- hwTemp
  let fts =
        filter
          (\(s,t) -> elem s tLabels)
          hwts
  let (s, t) = head fts
  return t

batStat :: IO (Float, String)
batStat = do
  es <- try (readFile "/sys/class/power_supply/BAT0/status") :: IO (Either SomeException String)
  case es of
    Left  e -> return (0, "AC")
    Right s -> do
      c <- readFile "/sys/class/power_supply/BAT0/capacity"
      return (read c :: Float, trim s)

vramStat :: IO (Float, Float)
vramStat = do
   vram_used <- readFile "/sys/class/drm/card0/device/mem_info_vram_used"
   vram <- readFile "/sys/class/drm/card0/device/mem_info_vram_total"
   return (read vram :: Float, read vram_used :: Float)

-- /sys/class/net/<iface>/operstate up
-- /sys/class/net/<iface>/carrier 1
-- /sys/class/net/<iface>/type [800-805]::wifi [1-10]::wired
iface = "enp6s0"
netStat :: IO [(String, String, Bool)] -- dev, type, up
netStat = do
  st <- readFile $ "/sys/class/net/"++iface++"/operstate"
  ln <- readFile $ "/sys/class/net/"++iface++"/carrier"
  ty <- readFile $ "/sys/class/net/"++iface++"/type"
  let up =
        if ((trim ln) == "1") && ((trim st) == "up")
          then True
          else False
      tn = read ty :: Int
      dt =
        if (tn > 800) && (tn < 805)
          then "wireless"
          else "wired"
  return [(iface, dt, up)]
