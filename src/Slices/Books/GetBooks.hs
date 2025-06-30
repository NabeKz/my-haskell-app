{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Books.GetBooks where

import qualified Data.ByteString.Lazy.Char8 as L8
import Servant
import Slices.Books.Types

-- API Definition
type GetBooksAPI = "books" :> Get '[JSON] [Book]

-- Repository Type Alias for DI
type GetAllBooks = IO (BookResult [Book])

-- In-Memory Repository Implementation
getAllBooksInMemory :: GetAllBooks
getAllBooksInMemory =
  return $
    Right
      [ Book (BookId 1) "Functional Programming in Haskell"
      ]

-- HTTP Handler with DI
getBooksHandler :: GetAllBooks -> Handler [Book]
getBooksHandler getAllBooksRepo = do
  result <- liftIO getAllBooksRepo
  case result of
    Left _ -> throwError err500 {errBody = L8.pack "Internal server error"}
    Right books -> return books
  where
    liftIO = liftIO
