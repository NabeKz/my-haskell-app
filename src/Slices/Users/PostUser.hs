{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Users.PostUser where

import Servant
import Slices.Users.Types
import qualified Data.ByteString.Lazy.Char8 as L8

-- API Definition
type PostUserAPI = "users" :> ReqBody '[JSON] User :> Post '[JSON] User

-- Data Access (Repository)
saveUserToRepo :: User -> IO User
saveUserToRepo user = return user -- In-memory for now

-- Business Logic (Service)
createUserService :: User -> IO (UserResult User)
createUserService user = do
  -- Validate the user (could add more validation here)
  case validateUser user of
    Left err -> return $ Left err
    Right validUser -> do
      savedUser <- saveUserToRepo validUser
      return $ Right savedUser

validateUser :: User -> UserResult User
validateUser user@(User _ name email)
  | null name = Left (InvalidUserInput "User name cannot be empty")
  | null email = Left (InvalidUserInput "User email cannot be empty")
  | not (isValidEmail email) = Left (InvalidUserInput "Invalid email format")
  | otherwise = Right user

-- HTTP Handler
postUserHandler :: User -> Handler User
postUserHandler user = do
  result <- liftIO $ createUserService user
  case result of
    Left (InvalidUserInput msg) -> throwError err400 { errBody = L8.pack msg }
    Left _ -> throwError err500 { errBody = L8.pack "Internal server error" }
    Right createdUser -> return createdUser
  where
    liftIO = liftIO
    throwError = throwError
    err400 = err400
    err500 = err500
    errBody = errBody
