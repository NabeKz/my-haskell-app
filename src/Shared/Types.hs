{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Shared.Types where

import Data.Aeson
import GHC.Generics

-- ID Types
newtype UserId = UserId Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

newtype BookId = BookId Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

-- Domain Types
data User = User
  { userId :: UserId,
    userName :: String,
    userEmail :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON User
instance FromJSON User

data Book = Book
  { bookId :: BookId,
    bookName :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON Book
instance FromJSON Book

-- Error Types
data DomainError
  = UserNotFound UserId
  | BookNotFound BookId
  | InvalidInput String
  deriving (Eq, Show)

type AppResult a = Either DomainError a

-- Domain Logic
mkUser :: Int -> String -> String -> Either DomainError User
mkUser id' name email
  | null name = Left (InvalidInput "User name cannot be empty")
  | null email = Left (InvalidInput "User email cannot be empty")
  | not (isValidEmail email) = Left (InvalidInput "Invalid email format")
  | otherwise = Right $ User (UserId id') name email

mkBook :: Int -> String -> Either DomainError Book
mkBook id' name
  | null name = Left (InvalidInput "Book name cannot be empty")
  | otherwise = Right $ Book (BookId id') name

isValidEmail :: String -> Bool
isValidEmail email = '@' `elem` email && '.' `elem` email