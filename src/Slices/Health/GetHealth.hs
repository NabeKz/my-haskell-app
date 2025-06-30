{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Slices.Health.GetHealth where

import Servant

-- API Definition
type GetHealthAPI = "health" :> Get '[JSON] String

-- Business Logic (Service)
getHealthService :: IO String
getHealthService = return "OK"

-- HTTP Handler
getHealthHandler :: Handler String
getHealthHandler = liftIO getHealthService
  where liftIO = liftIO