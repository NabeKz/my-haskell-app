{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Books.GetBooks where

import Servant
import Slices.Books.Types
import qualified Data.ByteString.Lazy.Char8 as L8

-- API Definition
type GetBooksAPI = "books" :> Get '[JSON] [Book]

-- Data Access (Repository)
getAllBooksFromRepo :: IO [Book]
getAllBooksFromRepo = return
  [ Book (BookId 1) "Functional Programming in Haskell"
  ]

-- Business Logic (Service)
getAllBooksService :: IO (BookResult [Book])
getAllBooksService = do
  books <- getAllBooksFromRepo
  return $ Right books

-- HTTP Handler
getBooksHandler :: Handler [Book]
getBooksHandler = do
  result <- liftIO getAllBooksService
  case result of
    Left _ -> throwError err500 { errBody = L8.pack "Internal server error" }
    Right books -> return books
  where
    liftIO = liftIO
    throwError = throwError
    err500 = err500
    errBody = errBody