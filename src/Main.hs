module Main where

import qualified Network.Socket as Net
import Network.Socket.ByteString (sendAll, recv)
import Data.ByteString.Char8 (unpack, pack)
import qualified Data.ByteString as B
import Http (generateGetHeader, parseBody)
import System.Environment (getArgs)

-- initialise a client socket
initClient :: IO Net.Socket
initClient = do
  let hints = Net.defaultHints {Net.addrSocketType = Net.Stream}
  addr:_ <- Net.getAddrInfo (Just hints) (Just "localhost") (Just "5000")
  sock <- Net.socket (Net.addrFamily addr) (Net.addrSocketType addr) (Net.addrProtocol addr)
  Net.setSocketOption sock Net.ReuseAddr 1
  Net.setSocketOption sock Net.NoDelay 0
  return sock

--continuously read from socket until it sends length 0 message (ie remote socket is finished sending)
readSock :: Net.Socket -> Int -> IO [B.ByteString] -> IO B.ByteString 
readSock _ 0 iob = fmap B.concat iob
readSock s _ m = do
  msg <- recv s 4096
  readSock s (B.length msg) $ m >>= (\p -> return(p++[msg]))

--send a message to remote socket and return its response
sendMessage :: String -> String -> String -> IO Net.Socket -> IO String
sendMessage remote port params iosock = do
  let bytes = pack $ generateGetHeader remote "/echo.php" params
  addr:_ <- Net.getAddrInfo Nothing (Just remote) (Just port) -- resolves hostname if hostname provided instead of ip
  sock <- iosock
  Net.connect sock (Net.addrAddress addr)
  sendAll sock bytes
  response <-  readSock sock 1 (return [])
  print response
  return $ parseBody $ unpack response

main :: IO ()
main = do
  (remote:port:msg:_) <- getArgs
  sock <- initClient
  re <- sendMessage remote port msg $ return sock
  putStrLn re
  Net.close sock
