import Control.Monad.Writer
import Control.Monad.State

newtype Count a = Count { getCount :: a }
    deriving (Eq, Ord, Read, Show, Bounded)

instance Num a => Monoid (Count a) where
    mempty = Count 0
    Count x `mappend` Count y = Count (x + y)

doSomething :: Int -> Writer (Count Int) Int
doSomething n = do
  mapM_ (\_ -> tell (Count 1)) [1..n]
  return n

data Stat = Stat
  { count :: Int
  , rate  :: Int
  } deriving (Show)

incCount :: StateT Stat IO ()
incCount = state (\s -> ((), s {count = count s + rate s}))

getStats :: StateT Stat IO Stat
getStats = state (\s -> (s, s))

doSomething2 :: StateT Stat IO ()
doSomething2 = do
  incCount
  --x <- getStats
  --liftIO $ print x
  getStats >>= \x -> liftIO (print x)
  incCount
  incCount
  return ()


main1 = do
  let r1 = runWriter $ doSomething 8
  print r1

  --https://stackoverflow.com/questions/32213779/is-it-possible-to-use-io-inside-state-monad-without-using-statet-and-st
  (s, v) <- runStateT doSomething2 (Stat 0 1)
  print v

main = main1

