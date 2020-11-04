# hsfun


== operators
'/=' -- not equals

== branch
let x = if n > 5
					then n
					else 10-n

== lists
3:[1,2] -- concat 3 to list
5:4:[1,2,3] -> 5:[1,2,3,4] -- concat chain right assoc
[1,2,3] !! i -- random access element i-1
[3,2,1] > [2,10,100] -> True -- lists can be compared lexicographically
a = [1,2,3]
	head a -> 1
	tail a -> [2,3]
	last a -> 3
	init a -> [1,2]
	length a -> 3
	null a -> False
	null [] -> True
	reverse -- reverse a list
	take 2 a -> [1,2]
	take 0 a -> []
	drop 2 a -> [3]
	minimum a -> 1
	sum
	product
	elem 3 a -> True
	[1..20] -> [1,2,3 .. 20]
	[2,4..20] -> [2,4,6,8 .. 20]
	cycle a -> [1,2,3,1,2, ...]
	repeat 42 -> [42,42, ...]
	replicate n x -> [x,x ... x(n times)]
	[x*x | x <- [2,4..20]]
	[if x > 7 then "down" else "up" | x <- [1..10], x > 3]
	[x | x <- [1..10], x /= 4, x < 7]
	[x*y | x <-[1..3], y<-[2,3], x*y < 9] -- cartesian product

== Tuples
a = (U, V ...)
	fst a -> U
	snd a -> V
	zip [1,3] [2,4] -> [(1,2),(3,4)]
	zip [1,3,5,7] [2,4] -> [(1,2),(3,4)] -- longer list truncated

== Types
intsum :: Int -> Int -> Int
head :: [a] -> a  -- type variable
div :: (Num a) => a -> a -> a -- type variable contraint
(*) :: (Num a) => a -> a -> a
(==) :: (Eq a) => a -> a -> Bool -- typeclass Eq
(>) :: (Ord a) => a -> a -> Bool
read x ::a -- parse a string x and convert to type a
read :: (Read a) => String -> a

== Functions
fac :: (Integral a) => a -> a -- pattern matching
fac 0 = 1
fac n = n * factorial (n - 1)

tell (x:y:[]) = ... -- destructuring a 2 el list

fn x	-- guards
	| x<2 = "go"
	| otherwise = "stay"

fn x y -- where
	| s < x2 = "big"
	| otherwise = "small"
	where s  = x*y
				x2 = x*x

fn a b = -- let
	let a2  = a*a
			b2  = b*b
			ab2 = 2*a*b
	in a2 + b2 + ab2

safeHead x =	-- case
	case x of
		[]   -> Nothing
		a:as -> a


