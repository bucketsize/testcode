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
									print ("got h="++show(ht)++" w="++show(wt))
									print (bmi (read wt::Float) (read ht::Float))
		_				 -> print "error: enter weight followed by height"
