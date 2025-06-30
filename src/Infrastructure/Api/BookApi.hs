{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Infrastructure.Api.BookApi where

import Domain.Book
import Servant

type BookAPI =
  "books" :> Get '[JSON] [Book]

bookApi :: Proxy BookAPI
bookApi = Proxy