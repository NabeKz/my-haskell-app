{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Application.Types where

import Domain.Common
import Domain.User
import Domain.Book
import Servant

type AppResult a = Either DomainError a

-- newtypeで包装してorphan instanceを避ける
newtype AppHandler a = AppHandler { runAppHandler :: Handler a }
  deriving (Functor, Applicative, Monad)

class UserRepository m where
  getAllUsers :: m [User]
  getUserById :: UserId -> m (Maybe User)
  createUser :: User -> m User

class BookRepository m where
  getAllBooks :: m [Book]
  getBookById :: BookId -> m (Maybe Book)
  createBook :: Book -> m Book

-- AppHandlerのインスタンス定義
instance UserRepository AppHandler where
  getAllUsers = AppHandler $
    return
      [ User (UserId 1) "Alice" "alice@example.com",
        User (UserId 2) "Bob" "bob@example.com"
      ]

  getUserById (UserId uid) = AppHandler $ return $ case uid of
    1 -> Just $ User (UserId 1) "Alice" "alice@example.com"
    2 -> Just $ User (UserId 2) "Bob" "bob@example.com"
    _ -> Nothing

  createUser user = AppHandler $ return user

instance BookRepository AppHandler where
  getAllBooks = AppHandler $
    return
      [ Book (BookId 1) "Functional Programming in Haskell"
      ]

  getBookById (BookId bid) = AppHandler $ return $ case bid of
    1 -> Just $ Book (BookId 1) "Functional Programming in Haskell"
    _ -> Nothing

  createBook book = AppHandler $ return book