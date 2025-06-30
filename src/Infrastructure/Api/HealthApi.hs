{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Infrastructure.Api.HealthApi where

import Servant

type HealthAPI =
  "health" :> Get '[JSON] String

healthApi :: Proxy HealthAPI
healthApi = Proxy