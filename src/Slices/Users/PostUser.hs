{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Users.PostUser where

import Servant
import Shared.AppHandler
import Shared.Types

-- API Definition
type PostUserAPI = "users" :> ReqBody '[JSON] User :> Post '[JSON] User

-- Data Access (Repository)
saveUserToRepo :: User -> IO User
saveUserToRepo user = return user -- In-memory for now

-- Business Logic (Service)
createUserService :: User -> IO (AppResult User)
createUserService user = do
  -- Validate the user (could add more validation here)
  case validateUser user of
    Left err -> return $ Left err
    Right validUser -> do
      savedUser <- saveUserToRepo validUser
      return $ Right savedUser

validateUser :: User -> AppResult User
validateUser user@(User _ name email)
  | null name = Left (InvalidInput "User name cannot be empty")
  | null email = Left (InvalidInput "User email cannot be empty")
  | not (isValidEmail email) = Left (InvalidInput "Invalid email format")
  | otherwise = Right user

-- HTTP Handler
postUserHandler :: User -> Handler User
postUserHandler user = do
  result <- liftIO $ createUserService user
  handleResult result
  where liftIO = liftIO