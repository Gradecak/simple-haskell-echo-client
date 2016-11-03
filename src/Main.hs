module Main where

import qualified Network.Socket as Net
import Network.Socket.ByteString (sendAll, recv)
import Data.ByteString.Char8 (unpack, pack)
import qualified Data.ByteString as B
import Data.List.Split (splitOn)
import System.Environment (getArgs)

-- initialise a client socket
initClient :: IO Net.Socket
initClient = do
  addr:_ <- Net.getAddrInfo Nothing (Just "localhost") (Just "5000")
  Net.socket (Net.addrFamily addr) Net.Stream Net.defaultProtocol

-- continuously read from socket until it sends length 0 message (ie remote socket is finished sending)
-- when finished reading concat all of the partial responses and return 
readSock :: Net.Socket -> Int -> IO [B.ByteString] -> IO B.ByteString 
readSock _ 0 iob = fmap B.concat iob
readSock s _ m = do
  msg <- recv s 4096
  readSock s (B.length msg) $ m >>= (\p -> return(p++[msg]))

-- generate a get header
genGetHeader :: String -> String -> String -> String
genGetHeader host resource param = concat ["GET ", resource, "?", param, " HTTP/1.1\r\n Host: ", host, "\r\n\r\n"]

--send a message to remote socket and return the parsed html reponse
sendMessage :: String -> String -> String -> String -> Net.Socket -> IO String
sendMessage remote port resource params sock = do
  addr:_ <- Net.getAddrInfo Nothing (Just remote) (Just port) -- resolves hostname if hostname provided instead of ip
  Net.connect sock (Net.addrAddress addr)                     -- connect to remote host
  sendAll sock $ pack $ genGetHeader remote resource params   -- send GET request
  response <-  readSock sock 1 (return [])                    -- read the response from the socket until socket upstream sends 0 len response
  return $ last $ splitOn "\r\n\r\n" $ unpack response        -- return the HTML BODY from response

-- main
main :: IO ()
main = do
  [remote,port,resource,msg] <- getArgs                         -- get arguments
  sock <- initClient                                            -- initialise socket to connect to remote host
  let m = concatMap (\y -> if y == ' ' then "%20" else [y]) msg -- if message param contains spaces change then to %20
  re <- sendMessage remote port resource m sock                 -- send message to server
  putStrLn re                                                   -- print parsed html response
  Net.close sock                                                -- cleanup and close socket
