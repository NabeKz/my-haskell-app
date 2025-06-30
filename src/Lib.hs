{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Lib
  ( startApp,
    app,
  )
where

import Application.BookService
import Application.UserService
import Application.Types
import Domain.Common
import Domain.User
import Domain.Book
import Infrastructure.Api.BookApi
import Infrastructure.Api.HealthApi
import Infrastructure.Api.UserApi
import Network.Wai
import Network.Wai.Handler.Warp
import Servant
import qualified Data.ByteString.Lazy.Char8 as L8

type API = UserAPI :<|> BookAPI :<|> HealthAPI

api :: Proxy API
api = Proxy

startApp :: IO ()
startApp = run 8080 app

getUsers :: Handler [User]
getUsers = do
  result <- runAppHandler getAllUsersService
  case result of
    Left _ -> throwError err500 {errBody = L8.pack "Internal server error"}
    Right users -> return users

postUser :: User -> Handler User
postUser user = return user

getUser :: Int -> Handler User
getUser uid = do
  result <- runAppHandler $ getUserByIdService (UserId uid)
  case result of
    Left (UserNotFound _) -> throwError err404 {errBody = L8.pack "User not found"}
    Left _ -> throwError err500 {errBody = L8.pack "Internal server error"}
    Right user -> return user

getHealth :: Handler String
getHealth = return "OK"

getBooks :: Handler [Book]
getBooks = do
  result <- runAppHandler getAllBooksService
  case result of
    Left _ -> throwError err500 {errBody = L8.pack "Internal server error"}
    Right books -> return books

app :: Application
app = serve api server

server :: Server API
server = (getUsers :<|> postUser :<|> getUser) :<|> getBooks :<|> getHealth