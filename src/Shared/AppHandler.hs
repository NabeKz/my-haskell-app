{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Shared.AppHandler where

import Servant
import Shared.Types
import qualified Data.ByteString.Lazy.Char8 as L8

-- Handler wrapper to avoid orphan instances
newtype AppHandler a = AppHandler { runAppHandler :: Handler a }
  deriving (Functor, Applicative, Monad)

-- Convert domain errors to HTTP errors
handleResult :: AppResult a -> Handler a
handleResult (Right x) = return x
handleResult (Left (UserNotFound _)) = 
  throwError err404 { errBody = L8.pack "User not found" }
handleResult (Left (BookNotFound _)) = 
  throwError err404 { errBody = L8.pack "Book not found" }
handleResult (Left (InvalidInput msg)) = 
  throwError err400 { errBody = L8.pack msg }