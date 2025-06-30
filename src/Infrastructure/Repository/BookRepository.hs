module Infrastructure.Repository.BookRepository where

import Domain.Book
import Domain.Common

data InMemoryBookRepo = InMemoryBookRepo

-- 具体的な書籍データ
sampleBooks :: [Book]
sampleBooks =
  [ Book (BookId 1) "Functional Programming in Haskell"
  ]

findBookById :: BookId -> Maybe Book
findBookById (BookId bid) = case bid of
  1 -> Just $ Book (BookId 1) "Functional Programming in Haskell"
  _ -> Nothing