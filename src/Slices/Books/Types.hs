{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Slices.Books.Types where

import Data.Aeson
import GHC.Generics

-- Book-specific types
newtype BookId = BookId Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

data Book = Book
  { bookId :: BookId,
    bookName :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON Book
instance FromJSON Book

-- Book-specific errors
data BookError
  = BookNotFound BookId
  | InvalidBookInput String
  deriving (Eq, Show)

type BookResult a = Either BookError a

-- Book-specific domain logic
mkBook :: Int -> String -> BookResult Book
mkBook id' name
  | null name = Left (InvalidBookInput "Book name cannot be empty")
  | otherwise = Right $ Book (BookId id') name