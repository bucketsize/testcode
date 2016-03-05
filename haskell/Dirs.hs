module Main where

import Control.Monad    (msum)
import Happstack.Server (dirs, nullConf, ok, seeOther, simpleHTTP)

main :: IO ()
main = simpleHTTP nullConf $
  msum [ dirs "hello/world"  $ ok "Hello, World!"
       , dirs "goodbye/moon" $ ok "Goodbye, Moon!"
       , seeOther "/hello/world" "/hello/world"
       ]
