-- modules
import Data.List
import qualified Data.Map as M
module Shape.2D.square
( perimeter
, area
) where
  perimeter :: (Num a) => a -> a
  area :: (Num a) => a -> a


-- operators
-- '/=' -> not equals

-- branch
let n = 7
let x = if n > 5
					then n
					else 10-n
putStrLn show(x)

-- lists
3:[1,2]  -- concat 3 to list
5:4:[1,2,3]  -- 5:[1,2,3,4] -- concat chain right assoc
[1,2,3] !! 2  -- random access element i-1
[3,2,1] > [2,10,100]  -- True -- lists can be compared lexicographically
let a = [1,2,3] 
head a  -- 1
tail a  -- [2,3]
last a  -- 3
init a  -- [1,2]
length a  -- 3
null a -- False
null []  -- True
reverse  -- reverse a list
take 2 a  -- [1,2]
take 0 a  -- []
takeWhile () []
drop 2 a  -- [3]
dropWhile
minimum a  -- 1
sum 
product 
elem 3 a  -- True
[1..20]  -- [1,2,3 .. 20]
[2,4..20]  -- [2,4,6,8 .. 20]
cycle a  -- [1,2,3,1,2, ...]
repeat 42  -- [42,42, ...]
replicate 5 x  -- [x,x ... x(n times)]
splitAt a [a]
break (a -> bool) [a] -- [1,2,3,4] => [1,2,3], [4] when a == 4


[x*x | x <- [2,4..20]] 
[if x > 7 then "down" else "up" | x <- [1..10], x > 3] 
[x | x <- [1..10], x /= 4, x < 7] 
[x*y | x <-[1..3], y<-[2,3], x*y < 9]  -- cartesian product

-- Tuples
let a = (47, "boo ha", false, [2,3,4])
fst a  -- U
snd a  -- V
zip [1,3] [2,4]  -- [(1,2),(3,4)]
zip [1,3,5,7] [2,4]  -- [(1,2),(3,4)] -- longer list truncated

-- Types
intsum :: Int -> Int -> Int
head :: [a] -> a  -- type variable
div :: (Num a) => a -> a -> a -- type variable contraint
(*) :: (Num a) => a -> a -> a
(==) :: (Eq a) => a -> a -> Bool -- typeclass Eq
(>) :: (Ord a) => a -> a -> Bool
read x ::a -- parse a string x and convert to type a
read :: (Read a) => String -> a

-- Functions
fac :: (Integral a) => a -> a -- pattern matching
fac 0 = 1
fac n = n * factorial (n - 1)

tell (x:y:[]) = [2,3] -- destructuring a 2 el list

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

-- curry
divby1 y x = x / y
divby2 y x = (/ y x) -- prefix
divby3 y x = (/y) x  -- curry
divby4 y   = (/y)    -- curry foo

-- higher order
map' :: (a -> b) -> [a] -> [b]
filter' :: (a -> bool) -> [a] -> [a]
fold`' :: (s a -> s) -> [a] -> s

-- Types
data Foo = Fizz Int
data Bar = Buzz Float
-- data <type> = <value constructor> ...

data FooBar = FooBar { fizz :: Int
                     , buzz :: Float
                     } deriving (Show)

-- Type paramater
data Maybe a = Nothing | Just a
-- data (Ord k) => Map k v = ...

-- Type synonyms
type String = [Char]

-- Self referential Types
data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

-- Type classes
class Eq a where  
    (==) :: a -> a -> Bool  
    (/=) :: a -> a -> Bool  
    x == y = not (x /= y)  
    x /= y = not (x == y)

-- Polymorphism with type classes
instance Eq FooBar where
  (==) x y = (fizz x == fizz y) and (buzz x == buzz y)

instance Show FooBar where
  show x = show (fizz x) ++ ", " ++ show (buzz x)

-- IO
doOp = IO String
doOp =  do
  x <- getLine
  putStrLn x

-- Functor
--  Box over which a function can be applied
class Functor f where
  fmap :: (a -> b) -> f a -> f b

instance Functor [a] where
  fmap :: (a -> b) -> [a] -> [b]

instance Functor Either a where
  fmap :: (b -> c) -> Either a b -> Either a c

-- (->) a b => (a -> b)
instance Functor (r->) where
  fmap :: (a -> b) -> ((r -> a) -> (r -> b))
  fmap f g = (\x -> f (g x))
  fmap = (.)

-- ex:
fmap (+50) (/2) (*3) 22

-- Applicative functor
--  Box over which a partial function is applied.
--  Box behaves like a function than can be applied to other functors.

class (Functor f) => Applicative f where
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b

pure ("Foo" ++) <*> Just "Bar" -- pure f = Just f
Just ("Foo" ++) <*> Just "Bar"
Just (++) <*> Just "Foo" <*> Just "Bar"
  -- -> Just "FooBar"

-- helper for bootstrapping f to a functor
(<$>) :: (Functor f) => (a -> b) -> f a -> f b
f <$> x = fmap f x

(++) <$> Just "Foo" <*> Just "Bar"
  -- -> Just "FooBar"

-- TODO
-- explain this
[(+1),(*100),(*5)] <*> [1,2,3]
  -- -> [2,3,4,100,200,300,5,10,15] 

-- TODO
-- Understand and list out instances of 
-- Applicative Functors: Maybe [] IO (->)

-- TODO
-- type vs. newtype vs. data wrt. (applicative) functors

-- Monoids

