{-# LANGUAGE OverloadedStrings #-}

import Control.Exception (catch)
import Control.Lens hiding ((.=))
import Data.Aeson (toJSON, (.=), object)
import Network.Wreq
import Data.Aeson.Lens (key, nth)
import System.Environment
import Data.ByteString.Char8 as BS
import Data.ByteString.Lazy.Char8 as LBS
import qualified Network.HTTP.Client as HTTP


base :: String
base = "https://demo-api.ig.com/gateway/deal"


(=:) :: String -> String -> (String, String)
(=:) = (,)


run
  :: String -- username
  -> String -- password
  -> BS.ByteString -- api key
  -> IO ()

test u p k =
  postWith (mkOpts k) "http://httpbin.org/post"
  (mkPayload u p)
  >>=
  (\r -> LBS.putStrLn (r^.responseBody))


mkPayload u p =
  object
    [ "identifier" .= u
    , "password" .= p
    ]

mkOpts apiKey =
  defaults
    & header "X-IG-API-KEY".~ [apiKey]
    & header "Content-Type" .~ ["application/json; charset=UTF-8"]
    & header "Accept" .~ ["application/json; charset=UTF-8"]
    -- & header "Version" .~ ["2"]

run username password apiKey =
  do r <- postWith (mkOpts apiKey) (base ++ "/session")
          $ mkPayload username password
     print r
     return ()

handler e@(HTTP.StatusCodeException status respHeaders cookieJar) =
  do print status
     print respHeaders

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
