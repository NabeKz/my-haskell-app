{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}

module Api where

import Data.Aeson
import GHC.Generics
import Servant

data User = User
  { userId :: Int
  , userName :: String
  , userEmail :: String
  } deriving (Eq, Show, Generic)

instance ToJSON User
instance FromJSON User

type API = "users" :> Get '[JSON] [User]
      :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User
      :<|> "users" :> Capture "id" Int :> Get '[JSON] User
      :<|> "health" :> Get '[JSON] String

api :: Proxy API
api = Proxy