import Network.HTTP.Conduit
import System.Environment (getArgs)
import qualified Data.ByteString.Lazy as L
import Control.Monad.IO.Class (liftIO)

main :: IO ()
main = do
    args <- getArgs
    case args of
        [urlString] ->
            case parseUrl urlString of
                Nothing -> putStrLn "Sorry, invalid URL"
                Just req -> withManager $ \manager -> do
                    let reqHead = req { method = "HEAD" }
                    res <- http reqHead manager
                    liftIO $ do
                        print $ responseStatus res
                        mapM_ print $ responseHeaders res
        _ -> putStrLn "Sorry, please provide example one URL"
