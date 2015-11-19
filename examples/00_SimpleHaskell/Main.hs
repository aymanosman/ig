-- {-# LANGUAGE OverloadedStrings #-}

import Network.Wreq
import Control.Lens
import Data.Aeson (toJSON)
import Data.Aeson.Lens (key, nth)
import System.Environment


base :: String
base = "https://demo-api.ig.com/gateway/deal"


(=:) :: String -> String -> (String, String)
(=:) = (,)


run :: String -> IO ()
run username =
  let -- json :: Value
      json =
        toJSON
          [ "identifier" =: username
          ]
      -- opts = defaults & header "Accept" .~ ["*/*"]
  in
  do r <- post (base ++ "/session")
          -- ["identifier" := username]
          json
     print r
     return ()


main :: IO ()
main =
  do args <- getArgs
     case args of
       [username] ->
         do _ <- run username
            return ()
       _ ->
         fail "Usage: main USERNAME"
