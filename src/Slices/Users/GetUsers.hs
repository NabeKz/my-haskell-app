{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Users.GetUsers where

import Servant
import Slices.Users.Types
import qualified Data.ByteString.Lazy.Char8 as L8

-- API Definition
type GetUsersAPI = "users" :> Get '[JSON] [User]

-- Data Access (Repository)
getAllUsersFromRepo :: IO [User]
getAllUsersFromRepo = return
  [ User (UserId 1) "Alice" "alice@example.com",
    User (UserId 2) "Bob" "bob@example.com"
  ]

-- Business Logic (Service)
getAllUsersService :: IO (UserResult [User])
getAllUsersService = do
  users <- getAllUsersFromRepo
  return $ Right users

-- HTTP Handler
getUsersHandler :: Handler [User]
getUsersHandler = do
  result <- liftIO getAllUsersService
  case result of
    Left _ -> throwError err500 { errBody = L8.pack "Internal server error" }
    Right users -> return users
  where 
    liftIO = liftIO
    throwError = throwError
    err500 = err500
    errBody = errBody