import System.Environment (getArgs)
import JbUtils

-- fn hellofn - !st
hellofn :: String -> String
hellofn y = foldl join "" (map helloize (splitLines isEOL y))
                        where 
                            helloize x = "hello:" ++ x ++ "\n"
                            join acc s = acc ++ s

-- fn Main
main :: IO() 
main = procFile hellofn
