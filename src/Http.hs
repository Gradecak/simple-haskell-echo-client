module Http where


generateGetHeader :: String -> -- Remote URL eg "www.host1.com:80"
                     String -> -- Remote Resource URL "/path/file.html"
                     String -> -- Poo
                     String    -- Returns  HTTP GET header 
generateGetHeader host resource auth = "GET " ++ resource ++ " HTTP/1.1\r\n" ++ "Host: " ++ host ++ "\r\n"
  ++ "Authorization: Basic " ++ auth ++ "\r\n"
  ++ "Accept-Encoding: gzip, deflate \r\n"
  ++ "Accept: text/htmlapplication/xhtml+xml,application/xml \r\n"
  ++ "Connection: Keep-Alive \r\n"
  ++ "Upgrade-Insecure-Requests: 1\r\n\r\n"
