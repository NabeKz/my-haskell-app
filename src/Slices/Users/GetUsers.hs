{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Users.GetUsers where

import Servant
import Shared.AppHandler
import Shared.Types

-- API Definition
type GetUsersAPI = "users" :> Get '[JSON] [User]

-- Data Access (Repository)
getAllUsersFromRepo :: IO [User]
getAllUsersFromRepo = return
  [ User (UserId 1) "Alice" "alice@example.com",
    User (UserId 2) "Bob" "bob@example.com"
  ]

-- Business Logic (Service)
getAllUsersService :: IO (AppResult [User])
getAllUsersService = do
  users <- getAllUsersFromRepo
  return $ Right users

-- HTTP Handler
getUsersHandler :: Handler [User]
getUsersHandler = do
  result <- liftIO getAllUsersService
  handleResult result
  where liftIO = liftIO