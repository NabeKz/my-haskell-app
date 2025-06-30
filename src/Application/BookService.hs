module Application.BookService where

import Application.Types
import Domain.Book
import Domain.Common

getAllBooksService :: (Monad m, BookRepository m) => m (AppResult [Book])
getAllBooksService = do
  books <- getAllBooks
  return $ Right books

getBookByIdService :: (Monad m, BookRepository m) => BookId -> m (AppResult Book)
getBookByIdService bookId = do
  maybeBook <- getBookById bookId
  case maybeBook of
    Nothing -> return $ Left (BookNotFound bookId)
    Just book -> return $ Right book

createBookService :: (Monad m, BookRepository m) => Int -> String -> m (AppResult Book)
createBookService id' name = do
  case mkBook id' name of
    Left err -> return $ Left err
    Right book -> do
      createdBook <- createBook book
      return $ Right createdBook