{-# LANGUAGE DeriveGeneric #-}

module Domain.User where

import Data.Aeson
import Domain.Common
import GHC.Generics

data User = User
  { userId :: UserId,
    userName :: String,
    userEmail :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON User

instance FromJSON User

mkUser :: Int -> String -> String -> Either DomainError User
mkUser id' name email
  | null name = Left (InvalidInput "User name cannot be empty")
  | null email = Left (InvalidInput "User email cannot be empty")
  | not (isValidEmail email) = Left (InvalidInput "Invalid email format")
  | otherwise = Right $ User (UserId id') name email

isValidEmail :: String -> Bool
isValidEmail email = '@' `elem` email && '.' `elem` email