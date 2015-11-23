{-# LANGUAGE OverloadedStrings #-}

import Control.Lens
import Data.Aeson (toJSON)
import Network.Wreq
import Data.Aeson.Lens (key, nth)
import System.Environment
import Data.ByteString.Char8 as BS


base :: String
base = "https://demo-api.ig.com/gateway/deal"


(=:) :: String -> String -> (String, String)
(=:) = (,)


run
  :: String -- username
  -> String -- password
  -> BS.ByteString -- api key
  -> IO ()



run username password apiKey =
  let -- json :: Value
      jsonPayload =
        toJSON
          [ "identifier" =: username
          , "passpord" =: password
          ]
  -- "Content-Type": "application/json; charset=UTF-8",
  -- "Accept": "application/json; charset=UTF-8",
      opts = defaults
        & header "X-IG-API-KEY".~ [apiKey]
        & header "Content-Type" .~ ["application/json", "charset=UTF-8"]
        & header "Accept" .~ ["application/json", "charset=UTF-8"]
  in
  do r <- postWith opts (base ++ "/session")
          jsonPayload
     print r
     return ()


main :: IO ()
main =
  do args <- getArgs
     case args of
       [username] ->
         let apiKey = "foo" -- BS
         in
         do _ <- run username "secret" apiKey
            return ()
       _ ->
         fail "Usage: main USERNAME"
