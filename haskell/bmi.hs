import System.Environment (getArgs)

-- fn bmi
bmi :: Float -> Float -> Float
bmi wt ht = wt/(ht^2)  

-- fn Main
main :: IO ()
main = do
	args <- getArgs
	case args of 
		[wt, ht] -> do
									putStr ("got h="++show(ht)++" w="++show(wt)++"\n")
									putStr ("bmi="++show(bmi (read wt::Float) (read ht::Float))++"\n")
		_				 -> putStr "error: enter weight followed by height\n"
