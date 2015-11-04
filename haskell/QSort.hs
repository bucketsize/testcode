import JbUtils

qsort :: (Ord a) => [a] -> [a]  
qsort [] = []  
qsort (x:xs) =   
    let l = qsort [a | a <- xs, a <= x]  
        r = qsort [a | a <- xs, a > x]  
    in  l ++ [x] ++ r

main :: IO()
main = procFile qsort
