module Main where

import qualified Network.Socket as Net
import qualified Network.Socket.ByteString as NetBs
import qualified Data.ByteString.Char8 as ByteS
import qualified Http (generateGetHeader)

initClient :: IO Net.Socket
initClient = do
  let hints = Net.defaultHints {Net.addrSocketType = Net.Stream}
  addr:_ <- Net.getAddrInfo (Just hints) (Just "localhost") (Just "5000")
  sock <- Net.socket (Net.addrFamily addr) (Net.addrSocketType addr) (Net.addrProtocol addr)
  Net.setSocketOption sock Net.ReuseAddr 1
  return sock

sendMessage :: IO Net.Socket -> IO()
sendMessage iosock = do
  let msg = Http.generateGetHeader "127.0.0.1" "/echo.php"
      bytes = ByteS.pack msg
      remoteAddr = Net.SockAddrInet 8000 ( Net.tupleToHostAddress (127, 0, 0, 1))
  print $ ByteS.length bytes
  sock <- iosock
  Net.connect sock remoteAddr
  _ <- NetBs.send sock bytes
  response <- NetBs.recv sock 4096
  print response

main :: IO ()
main = do
  sock <- initClient
  sendMessage $ return sock
  putStrLn "hello worl"
