import Utils
import SysFns
import SysCtl
import Text.Printf (printf)

main :: IO ()
main = do
  findFiles "/var/log" >>= (mapM_ (\f -> putStrLn f))
  test_hwTemp
  test_cpuTemp
  test_batStat
  test_vramStat
  test_netStat

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
