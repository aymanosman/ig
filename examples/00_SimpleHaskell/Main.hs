{-# LANGUAGE OverloadedStrings #-}
import Control.Exception (catch)
import Control.Monad ((<=<))
import Control.Lens hiding ((.=))
import Data.Aeson (toJSON, (.=), object, Value)
import Network.Wreq
import Data.Aeson.Lens (key, nth)
import System.Environment
import Data.ByteString.Char8 as BS
import Data.ByteString.Lazy.Char8 as LBS
import Data.Maybe (isJust, fromJust)
import qualified Network.HTTP.Client as HTTP
import qualified Data.Ini as Ini
import qualified Data.Text as Text
import qualified Data.List as List


base :: String
base = "https://demo-api.ig.com/gateway/deal"


(=:) :: String -> String -> (String, String)
(=:) = (,)


run
  :: String -- username
  -> String -- password
  -> String -- api key
  -> IO ()

test1 =
  postWith (mkOpts "api-key-123") "http://httpbin.org/post"
  (mkPayload "username-123" "password-123")
  >>=
  (\r -> LBS.putStrLn (r^.responseBody))


mkPayload :: String -> String -> Value
mkPayload u p =
  object
    [ "identifier" .= u
    , "password" .= p
    ]


mkOpts apiKey =
  defaults
    & header "X-IG-API-KEY".~ [BS.pack apiKey]
    & header "Content-Type" .~ ["application/json; charset=UTF-8"]
    & header "Accept" .~ ["application/json; charset=UTF-8"]
    -- & header "Version" .~ ["2"]


run username password apiKey =
  do r <- postWith (mkOpts apiKey) (base ++ "/session")
          $ mkPayload username password
     print r
     return ()


run' u p k =
  do _ <- run u p k
     return ()


handler e@(HTTP.StatusCodeException status respHeaders cookieJar) =
  do print status
     print respHeaders


main :: IO ()
main =
  do args <- getArgs
     case args of
       [anyfoo] ->
         maybe
           (fail "Failed to get creds from .env file")
           (\(username, password, apiKey) ->
              run' username password apiKey)
          =<<
          getCreds ".env"

       _ ->
         fail "Usage: main anyfoofornow"


-- return Creds (username, password, api key)
getCreds filename =
  either
    fail
    getCredsFromIni
    =<<
    Ini.readIniFile filename


getCredsFromIni ini =
  let mp = lookup' "password" ini
      mu = lookup' "username" ini
      mk = lookup' "api_key" ini
  in
  if List.all isJust [mu, mp, mk] then
    return $ Just
      ( fromJust mu
      , fromJust mp
      , fromJust  mk
      )
  else
    return Nothing


lookup' key ini =
  case Ini.lookupValue "default" key ini of
    Right p ->
      Just (Text.unpack p)
    _ ->
      Nothing
