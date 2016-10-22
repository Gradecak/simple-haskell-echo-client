module Server where

import qualified Network.Socket as Net
import qualified Network.Socket.ByteString as NetBs
import qualified Data.ByteString.Char8 as ByteS
import qualified Data.List as List
type Action = (Char, Char)
data Server s i a = Server (IO Net.Socket) (IO Net.AddrInfo) [Action]

-- action :: String -> Net.Socket -> IO()
-- action msg sock | not (null msg) = do
--                       print msg
--                       _ <- NetBS.send sock $ ByteS.pack msg
--                       handle sock a
--                   | otherwise = print "No response, closing connection"

-- handle :: Net.Socket -> [Action] -> IO()
-- handle sock actions = do
--   msg <- NetBS.recv sock 1024
--   -- action (ByteS.unpack msg) sock actions
--   Net.close sock
lookup :: [Char] -> [Action] -> Maybe [Char]
lookup s a = List.find ( (==) s . fst) a


-- handle :: Net.Socket -> [Action] -> IO()
-- handle sock actions = do
--   incoming <- NetBs.recv sock 1024
--   let action = 

listenIncoming :: Server s i a -> IO()
listenIncoming server@(Server iosock _ a) = do
  sock <- iosock
  (s,_) <- Net.accept sock
  print "Accepted incoming connection..."
  -- handle s a
  listenIncoming server

-- initialise the server datatype
initServer :: String ->    -- hostname
              String ->    -- port
              Int ->       -- number of connections the server can accept at once
              [Action] ->  --  a list of tuples where the first element is the input message and second is the response message
              Server s i a -- returns an instance of Server datatype
initServer host port con = Server sock ioaddr  where
  ioaddr = do
    let hints = Net.defaultHints { Net.addrSocketType = Net.Stream}
    Net.getAddrInfo (Just hints) (Just host) (Just port) >>= (\x -> return(Prelude.head x))
  sock = do
    addr <- ioaddr
    s <- Net.socket (Net.addrFamily addr) (Net.addrSocketType addr) (Net.addrProtocol addr)
    Net.setSocketOption s Net.ReuseAddr 1
    Net.bind s (Net.addrAddress addr)
    Net.listen s con 
    return s
