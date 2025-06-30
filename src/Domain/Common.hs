{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Domain.Common where

import Data.Aeson
import GHC.Generics

newtype UserId = UserId Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

newtype BookId = BookId Int
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

data DomainError
  = UserNotFound UserId
  | BookNotFound BookId
  | InvalidInput String
  deriving (Eq, Show)