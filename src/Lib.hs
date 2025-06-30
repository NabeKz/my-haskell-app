module Lib
  ( startApp,
    app,
  )
where

import Api
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

startApp :: IO ()
startApp = run 8080 app

getUsers :: Handler [User]
getUsers =
  return
    [ User 1 "Alice" "alice@example.com",
      User 2 "Bob" "bob@example.com"
    ]

postUser :: User -> Handler User
postUser user = return user

getUser :: Int -> Handler User
getUser uid = return $ User uid "User" "user@example.com"

getHealth :: Handler String
getHealth = return "OK"

getBooks :: Handler [Book]
getBooks =
  return
    [ Book 1 "hoge"
    ]

app :: Application
app = serve api server

server :: Server API
server = getUsers :<|> postUser :<|> getUser :<|> getHealth :<|> getBooks