import Utils
import SysFns
import SysCtl
import Text.Printf (printf)
import Control.Monad.Coroutine (Coroutine, pogoStick)
import Control.Monad.Coroutine.SuspensionFunctors
import Control.Monad.Trans.Class (lift)
import Control.Monad.IO.Class (liftIO)


main :: IO ()
main = do
  findFiles "/var/log" >>= (mapM_ (\f -> putStrLn f))
  test_hwTemp
  test_cpuTemp
  test_batStat
  test_vramStat
  test_netStat
  test_coRoutine

test_hwTemp =  do
  t <- hwTemp
  mapM_
    (\(s, t) -> printf "%s: %f\n" s t)
    t
test_cpuTemp = do
  t <- cpuTemp
  putStrLn $ "cpuTemp: " ++ (show t)

test_batStat = do
  (c, s) <- batStat
  printf "batStat: %f %s\n" c s

test_vramStat = do
  (t, f) <- vramStat
  printf "vramStat: %f %f\n" t f

test_netStat = do
  devs <- netStat
  let (dev, typ, up) = head devs
  printf "netStat: %s %s %s\n" dev typ (show up)

test_coRoutine = do
  liftIO $ printProduce producer

producer :: Coroutine (Yield Int) IO ()
producer = do
  series 1 1
  return ()
  where
    series x i = do
      yield x
      y <- lift (add x i)
      if y>10
        then return ()
        else series (x+i) i

add :: Int -> Int -> IO Int
add x i = do
  return (x+i)

printProduce :: Show x => Coroutine (Yield x) IO r -> IO r
printProduce producer =
  pogoStick
  (\(Yield x cont) -> lift (print x) >> cont)
  (producer)
