import System.Environment

main = do
  (l:ls) <- (words `fmap` getContents)
  let t = (read l::Int)
  print t
