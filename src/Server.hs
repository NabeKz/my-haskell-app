{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server where

import Network.Wai
import Servant
import Slices.Books.GetBooks
import Slices.Health.GetHealth
import Slices.Users.GetUser
import Slices.Users.GetUsers
import Slices.Users.PostUser

-- Combined API from all slices
type API = GetUsersAPI :<|> PostUserAPI :<|> GetUserAPI :<|> GetBooksAPI :<|> GetHealthAPI

api :: Proxy API
api = Proxy

-- Combined server from all slice handlers
server :: Server API
server = getUsersHandler :<|> postUserHandler :<|> getUserHandler :<|> getBooksHandler :<|> getHealthHandler

-- WAI Application
app :: Application
app = serve api server