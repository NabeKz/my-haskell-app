{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Books.GetBooks where

import qualified Data.ByteString.Lazy.Char8 as L8
import Servant
import Slices.Books.Types

-- API Definition
type GetBooksAPI = "books" :> Get '[JSON] [Book]

-- Repository Interface
class BookRepository m where
  getAllBooks :: m [Book]

-- In-Memory Repository Implementation
data InMemoryBookRepo = InMemoryBookRepo

instance BookRepository IO where
  getAllBooks =
    return
      [ Book (BookId 1) "Functional Programming in Haskell"
      ]

-- Business Logic (Service) with DI
getAllBooksService :: (Monad m, BookRepository m) => m (BookResult [Book])
getAllBooksService = do
  Right <$> getAllBooks

-- HTTP Handler
getBooksHandler :: Handler [Book]
getBooksHandler = do
  result <- liftIO (getAllBooksService :: IO (BookResult [Book]))
  case result of
    Left _ -> throwError err500 {errBody = L8.pack "Internal server error"}
    Right books -> return books
  where
    liftIO = liftIO