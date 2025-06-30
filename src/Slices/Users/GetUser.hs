{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Users.GetUser where

import Servant
import Shared.AppHandler
import Shared.Types

-- API Definition
type GetUserAPI = "users" :> Capture "id" Int :> Get '[JSON] User

-- Data Access (Repository)
getUserByIdFromRepo :: UserId -> IO (Maybe User)
getUserByIdFromRepo (UserId uid) = return $ case uid of
  1 -> Just $ User (UserId 1) "Alice" "alice@example.com"
  2 -> Just $ User (UserId 2) "Bob" "bob@example.com"
  _ -> Nothing

-- Business Logic (Service)
getUserByIdService :: UserId -> IO (AppResult User)
getUserByIdService userId = do
  maybeUser <- getUserByIdFromRepo userId
  case maybeUser of
    Nothing -> return $ Left (UserNotFound userId)
    Just user -> return $ Right user

-- HTTP Handler
getUserHandler :: Int -> Handler User
getUserHandler uid = do
  result <- liftIO $ getUserByIdService (UserId uid)
  handleResult result
  where liftIO = liftIO