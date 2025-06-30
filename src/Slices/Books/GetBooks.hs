{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Books.GetBooks where

import Servant
import Shared.AppHandler
import Shared.Types

-- API Definition
type GetBooksAPI = "books" :> Get '[JSON] [Book]

-- Data Access (Repository)
getAllBooksFromRepo :: IO [Book]
getAllBooksFromRepo = return
  [ Book (BookId 1) "Functional Programming in Haskell"
  ]

-- Business Logic (Service)
getAllBooksService :: IO (AppResult [Book])
getAllBooksService = do
  books <- getAllBooksFromRepo
  return $ Right books

-- HTTP Handler
getBooksHandler :: Handler [Book]
getBooksHandler = do
  result <- liftIO getAllBooksService
  handleResult result
  where liftIO = liftIO