module Main where

import qualified Network.Socket as Net
import qualified Network.Socket.ByteString as NetBs
import qualified Data.ByteString.Char8 as ByteS
import qualified Data.ByteString.Base64 as Base64 
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
  let msg = Http.generateGetHeader "www.scss.tcd.ie" "/Stephen.Barrett/lectures/cs4032/echo.php" "Z3JhZGVjYW06VnVrb3Zhcjkx"
      bytes = ByteS.pack msg
  putStr msg
  print $ ByteS.length bytes
  addr:_ <- Net.getAddrInfo (Just Net.defaultHints {Net.addrSocketType = Net.Stream}) (Just "www.scss.tcd.ie") (Just "80")
  sock <- iosock
  print (Net.addrAddress addr)
  Net.connect sock (Net.addrAddress addr)
  len <- NetBs.send sock bytes
  print len
  response <- NetBs.recv sock 4096
  print "got here"
  print response

main :: IO ()
main = do
  sock <- initClient
  sendMessage $ return sock
  putStrLn "hello worl"

