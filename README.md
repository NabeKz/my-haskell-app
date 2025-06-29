# my-haskell-app

A simple REST API server built with Servant in Haskell.

## Usage

```bash
# Install dependencies
cabal update
cabal build

# Run the server
cabal run
```

## API Endpoints

- `GET /users` - Get all users
- `POST /users` - Create a new user
- `GET /users/:id` - Get user by ID
- `GET /health` - Health check

## Example

```bash
# Get all users
curl http://localhost:8080/users

# Create a new user
curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{"userId": 3, "userName": "Charlie", "userEmail": "charlie@example.com"}'

# Get user by ID
curl http://localhost:8080/users/1

# Health check
curl http://localhost:8080/health
```