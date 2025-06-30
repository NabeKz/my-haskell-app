{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Slices.Users.Types where

import Data.Aeson
import GHC.Generics

-- User-specific types
newtype UserId = UserId Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

data User = User
  { userId :: UserId,
    userName :: String,
    userEmail :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON User
instance FromJSON User

-- User-specific errors
data UserError
  = UserNotFound UserId
  | InvalidUserInput String
  deriving (Eq, Show)

type UserResult a = Either UserError a

-- User-specific domain logic
mkUser :: Int -> String -> String -> UserResult User
mkUser id' name email
  | null name = Left (InvalidUserInput "User name cannot be empty")
  | null email = Left (InvalidUserInput "User email cannot be empty")
  | not (isValidEmail email) = Left (InvalidUserInput "Invalid email format")
  | otherwise = Right $ User (UserId id') name email

isValidEmail :: String -> Bool
isValidEmail email = '@' `elem` email && '.' `elem` email