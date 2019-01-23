import qualified System.IO.Streams.File as File
import qualified System.IO.Streams as Streams
import qualified System.IO as SysIo
import qualified Data.ByteString as ByteString

main :: IO ()
main = do
    putStrLn "streamFileEx1"
    streamFileEx1

    putStrLn "streamFileEx2"
    streamFileEx2

    putStrLn "streamConnectEx1"
    streamConnectEx1

streamFileEx1::IO()
streamFileEx1 = do
    File.withFileAsInput "res/words.in" (\stream -> do
        b <- Streams.read stream
        case b of
            Just b  -> ByteString.putStrLn b
            Nothing -> putStrLn "EOF"
        )

streamFileEx2::IO()
streamFileEx2 = do
    SysIo.withFile "res/words.in" SysIo.ReadMode (\hndl -> do
        stream <- Streams.handleToInputStream hndl
        b <- Streams.read stream
        case b of
            Just b  -> ByteString.putStrLn b
            Nothing -> putStrLn "EOF"
        )

streamConnectEx1::IO()
streamConnectEx1 = do
    File.withFileAsInput "res/words.in" (\inStream -> do
        File.withFileAsOutput "res/words.out" (\outStream -> do
            Streams.connect inStream outStream
            )
        )

