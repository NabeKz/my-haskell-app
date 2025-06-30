module Main (main) where

import Network.Wai.Handler.Warp (run)
import Server (app)

main :: IO ()
main = do
  putStrLn "Starting REST API server on http://localhost:8080"
  putStrLn "Available endpoints:"
  putStrLn "  GET  /users      - Get all users"
  putStrLn "  POST /users      - Create a new user"
  putStrLn "  GET  /users/:id  - Get user by ID"
  putStrLn "  GET  /books      - Get all books"
  putStrLn "  GET  /health     - Health check"
  run 8080 app