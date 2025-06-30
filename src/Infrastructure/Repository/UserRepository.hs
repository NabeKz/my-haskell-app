module Infrastructure.Repository.UserRepository where

import Domain.Common
import Domain.User

data InMemoryUserRepo = InMemoryUserRepo

-- 具体的なユーザーデータ
sampleUsers :: [User]
sampleUsers =
  [ User (UserId 1) "Alice" "alice@example.com",
    User (UserId 2) "Bob" "bob@example.com"
  ]

findUserById :: UserId -> Maybe User
findUserById (UserId uid) = case uid of
  1 -> Just $ User (UserId 1) "Alice" "alice@example.com"
  2 -> Just $ User (UserId 2) "Bob" "bob@example.com"
  _ -> Nothing