import Control.Monad
import System.IO
import System.Posix.Files
import Hw.Utils
import System.Process

ipcpipe = "/tmp/hw-sd.fifo"

data SD = SD
  { sndVol :: Int
  , wallpaper :: Wallpaper
  , state :: String
  } deriving (Show)

data Wallpaper = Wallpaper
  { url :: String
  , desc :: String
  , author :: String
  , time :: String
  } deriving (Show)

main :: IO ()
main = do
  createNamedPipe ipcpipe $ unionFileModes ownerReadMode ownerWriteMode
  pipe <- openFile ipcpipe ReadWriteMode
  startSD pipe SD
    {state="created"
    , sndVol = 10
    , wallpaper = Wallpaper
      { url = ""
      , desc = ""
      , author = ""
      , time = ""
      }
    }

startSD :: Handle -> SD -> IO ()
startSD pipe sd = do
  forever (hGetLine pipe >>= cmdHandler)

cmdHandler :: String -> IO ()
cmdHandler cmd = do
  let cmd' = splitOn (\x -> x == ' ') cmd
  case cmd' !! 0 of
    "volume-up" -> putStrLn "vol-up"
    "volume-down" -> putStrLn "vol-up"
    "wallpaper-refresh" -> putStrLn "vol-up"
    _ -> putStrLn $ show(cmd) ++ " -> unknown command"
