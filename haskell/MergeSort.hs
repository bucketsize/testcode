import Utils
import System.Environment

mergeSort :: (Ord a) => [a] -> [a]  
mergeSort [] = []  
mergeSort (x:xs) =   
    let l = mergeSort [a | a <- xs, a <= x]  
        r = mergeSort [a | a <- xs, a > x]  
    in  l ++ [x] ++ r

main :: IO()
main = do
  [inf, ouf] <- getArgs
  s <- readFile inf
  writeFile ouf (unlines (mergeSort (lines s)))
