{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module SysCtl where

import Control.Monad
import Control.Monad.IO.Class
import Prelude hiding (lookup)
import Data.Map (Map, fromList, lookup)
import System.Process
import Text.Regex.TDFA
import Text.Printf

data Monitor = Monitor
  { output :: String
  , mode :: String
  , position :: String
  }

data Sound = Sound
  { device :: String
  , level :: Int
  }

monitorUp   m = printf "xrandr --output %s --mode %s --pos %s --rotate normal" (output m) (mode m) (position m)
monitorDown m = printf "xrandr --output %s --off" (output m)

monitor00 = Monitor { output="DisplayPort-0", mode="1280x720", position= "0x0" }
monitor01 = Monitor { output="HDMI-A-0", mode="1280x720", position= "1280x0"  }

cmds = fromList $
  [
   -- startup
   ("video", monitorUp monitor00 ++ " --primary; " ++ monitorDown monitor01)
  ,("compositer", "picom")
  ,("wallpaper", "~/scripts/xdg/x.wallpaper.sh cycle")
  ,("notifyd", "dunst")
  -- ,("systray", "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x111111 --height 18")
  ,("nmapplet", "nm-applet --sm-disable")
  ,("audio", "~/scripts/sys_ctl/ctl.lua fun pa_set_default")
  ,("autolock", "~/scripts/sys_ctl/ctl.lua cmd autolockd_xautolock")
  ,("sysmon", "~/scripts/sys_mon/daemon.lua")

  -- commands
  -- pulseaudio
  ,("vol_up", "pactl set-sink-volume @DEFAULT_SINK@ +10%")
  ,("vol_down", "pactl set-sink-volume @DEFAULT_SINK@ -10%")
  ,("vol_mute", "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  ,("vol_unmute", "pactl set-sink-mute @DEFAULT_SINK@ toggle")

  -- i3 lock
  ,("scr_lock", "sh ~/scripts/xdg/x.lock-i3.sh")

  -- imagemagik
  ,("scr_cap", "import -window root ~/Pictures/sc-$(date +%Y%m%dT%H%M%S).png")
  ,("scr_cap_sel", "import ~/Pictures/sc-$(date +%Y%m%dT%H%M%S).png")

  ,("kb_led_on", "xset led on")
  ,("kb_led_off", "xset led off")
  ]


scr_lock_if_pa_is_active :: IO (Maybe String)
scr_lock_if_pa_is_active = do
  s <- pa_is_active
  if s then
       return (lookup "scr_lock" cmds)
  else
       return Nothing

pa_is_active :: IO Bool
pa_is_active = do
  ss <- readProcess "pacmd" ["list-sinks-inputs"] []
  let m = ss =~ "state: RUNNING.*" :: Bool
  return m

pa_set_default :: IO (Maybe String)
pa_set_default = do
  ss <- readProcess "pacmd" ["list-sinks"] []
  let (a,b,c,m) = ss =~ "name:[[:blank:]]<(.+analog.stereo)>" :: (String, String, String, [String])
  return (Just ("pacmd set-default-sink " ++ (m!!0)))

funs = fromList $
  [ ("scr_lock_if_pa_is_active", scr_lock_if_pa_is_active)
  , ("pa_set_default", pa_set_default)
  ]

dispatch :: String -> Maybe String
dispatch cmd = do
  let s = lookup cmd funs
  case s of
    Just x  -> s
    Nothing -> lookup cmd cmds
