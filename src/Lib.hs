module Lib
    ( startApp
    , app
    ) where

import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import Api

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

server :: Server API
server = getUsers :<|> postUser :<|> getUser :<|> getHealth
  where
    getUsers :: Handler [User]
    getUsers = return
      [ User 1 "Alice" "alice@example.com"
      , User 2 "Bob" "bob@example.com"
      ]
    
    postUser :: User -> Handler User
    postUser user = return user
    
    getUser :: Int -> Handler User
    getUser uid = return $ User uid "User" "user@example.com"
    
    getHealth :: Handler String
    getHealth = return "OK"