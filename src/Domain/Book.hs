{-# LANGUAGE DeriveGeneric #-}

module Domain.Book where

import Data.Aeson
import Domain.Common
import GHC.Generics

data Book = Book
  { bookId :: BookId,
    bookName :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON Book

instance FromJSON Book

mkBook :: Int -> String -> Either DomainError Book
mkBook id' name
  | null name = Left (InvalidInput "Book name cannot be empty")
  | otherwise = Right $ Book (BookId id') name