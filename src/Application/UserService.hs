module Application.UserService where

import Application.Types
import Domain.Common
import Domain.User

getAllUsersService :: (Monad m, UserRepository m) => m (AppResult [User])
getAllUsersService = do
  users <- getAllUsers
  return $ Right users

getUserByIdService :: (Monad m, UserRepository m) => UserId -> m (AppResult User)
getUserByIdService userId = do
  maybeUser <- getUserById userId
  case maybeUser of
    Nothing -> return $ Left (UserNotFound userId)
    Just user -> return $ Right user

createUserService :: (Monad m, UserRepository m) => Int -> String -> String -> m (AppResult User)
createUserService id' name email = do
  case mkUser id' name email of
    Left err -> return $ Left err
    Right user -> do
      createdUser <- createUser user
      return $ Right createdUser