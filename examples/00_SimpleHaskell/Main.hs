-- {-# LANGUAGE OverloadedStrings #-}

import Network.Wreq


base :: String
base = "https://demo-api.ig.com/gateway/deal"


run =
  do r <- post (base ++ "/session")
          ["identifier" := "aosman"]
     return r


main =
  do _ <- run
     return ()
