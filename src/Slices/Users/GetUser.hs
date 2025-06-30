{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Users.GetUser where

import Servant
import Slices.Users.Types
import qualified Data.ByteString.Lazy.Char8 as L8

-- API Definition
type GetUserAPI = "users" :> Capture "id" Int :> Get '[JSON] User

-- Data Access (Repository)
getUserByIdFromRepo :: UserId -> IO (Maybe User)
getUserByIdFromRepo (UserId uid) = return $ case uid of
  1 -> Just $ User (UserId 1) "Alice" "alice@example.com"
  2 -> Just $ User (UserId 2) "Bob" "bob@example.com"
  _ -> Nothing

-- Business Logic (Service)
getUserByIdService :: UserId -> IO (UserResult User)
getUserByIdService userId = do
  maybeUser <- getUserByIdFromRepo userId
  case maybeUser of
    Nothing -> return $ Left (UserNotFound userId)
    Just user -> return $ Right user

-- HTTP Handler
getUserHandler :: Int -> Handler User
getUserHandler uid = do
  result <- liftIO $ getUserByIdService (UserId uid)
  case result of
    Left (UserNotFound _) -> throwError err404 { errBody = L8.pack "User not found" }
    Left _ -> throwError err500 { errBody = L8.pack "Internal server error" }
    Right user -> return user
  where
    liftIO = liftIO
    throwError = throwError
    err404 = err404
    err500 = err500
    errBody = errBody