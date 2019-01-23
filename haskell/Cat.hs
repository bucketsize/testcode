import qualified System.Environment as SysEnv
import qualified System.IO.Streams.File as File
import qualified System.IO.Streams as Streams

main :: IO ()
main = do
    args <- SysEnv.getArgs
    case args of
        [inf] -> do
            File.withFileAsInput inf (\inStream -> do
                Streams.connect inStream Streams.stdout
                )
        [] -> print "error: expect 1 file"

