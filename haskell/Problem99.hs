main :: IO()
main = putStrLn "99 Problems of Haskell"

dub :: (Num a) => a -> a
dub x = x + x

hypot :: (Num a, Floating a) => a -> a -> a
hypot x y = sqrt (x*x + y*y)

dubIfSmall :: (Num a, Ord a) => a -> a
dubIfSmall x = ( if x > 100 then x else x *2) + 1

fact :: Integer -> Integer
fact 0 = 1
fact n = n * fact (n-1)

fib :: Integer -> Integer
fib 1 = 1
fib 2 = 1
fib x = fib(x-1) + fib(x-2)

-- 99 problems of haskell
-- 1
myLast :: [a] -> a
myLast [x] = x
myLast (x:xs) = myLast xs

-- 2
b4Last :: [a] -> a
b4Last [x,_] = x
b4Last (x:xs) = b4Last xs

-- 3
elAt :: [a] -> Int -> a
elAt x y = myLast (take y x) -- using prev defined

elAt' (x:xs) 1 = x
elAt' (x:xs) y = elAt' xs (y-1)

-- 4 
lenOf :: [a] -> Integer
lenOf [x] = 1
lenOf (x:xs) = 1 + lenOf xs

-- 5
revOf :: [a] -> [a]
revOf [] = []
revOf x = [last x] ++ revOf (init x)

revOf' [] = []
revOf' (x:xs) = revOf' xs ++ [x]

