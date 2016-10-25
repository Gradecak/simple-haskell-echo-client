module Http where

import Data.List.Split (splitOn)

generateGetHeader :: String -> -- Remote URL eg "www.host1.com:80"
                     String -> -- Remote Resource URL "/path/file.html"
                     String -> -- Paramater and its value
                     String    -- Returns  HTTP GET header 
generateGetHeader host resource params =
  "GET " ++ resource ++ "?" ++ params ++ " HTTP/1.1\r\n"
  ++ "Host: " ++ host ++ "\r\n"
  ++ "Accept-Encoding: gzip, deflate \r\n"
  ++ "Accept: text/htmlapplication/xhtml+xml,application/xml \r\n"
  ++ "Connection: keep-alive \r\n\r\n"

-- remove the headers and return the body of a given http string 
parseBody:: String -> -- http string
            String    -- returned body of http string 
parseBody res = last (splitOn "\r\n\r\n" res )
