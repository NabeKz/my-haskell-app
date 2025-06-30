{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Infrastructure.Api.UserApi where

import Domain.User
import Servant

type UserAPI =
  "users" :> Get '[JSON] [User]
    :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User
    :<|> "users" :> Capture "id" Int :> Get '[JSON] User

userApi :: Proxy UserAPI
userApi = Proxy