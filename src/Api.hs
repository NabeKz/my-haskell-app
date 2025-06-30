{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Api where

import Data.Aeson
import GHC.Generics
import Servant

data User = User
  { userId :: Int,
    userName :: String,
    userEmail :: String
  }
  deriving (Eq, Show, Generic)

data Book = Book
  { bookId :: Int,
    bookName :: String
  }
  deriving (Eq, Show, Generic)

instance ToJSON User

instance ToJSON Book

instance FromJSON User

type API =
  "users" :> Get '[JSON] [User]
    :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User
    :<|> "users" :> Capture "id" Int :> Get '[JSON] User
    :<|> "health" :> Get '[JSON] String
    :<|> "books" :> Get '[JSON] [Book]

api :: Proxy API
api = Proxy