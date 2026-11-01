# Data Model: User Login and Logout

## Existing entities

### User

Existing identity authenticated by username and password.

- `username`: normalized, unique login identifier.
- `password_digest`: existing password verifier; plaintext passwords are never persisted.
- `status`: active or suspended; only active users may sign in.

### Membership

Existing relationship between a user and an account, including active state and account role. A session is issued only for an active membership with account-scoped access.

### ApiToken

Existing revocable authenticated session record.

- `user_id`, `account_id`, `membership_id`: identity and access context.
- `token_digest`: digest of the secret token; the raw token is not stored.
- `expires_at`: session expiration, defaulting to 12 hours unless configured.
- `revoked_at`: set when the user signs out.
- `last_used_at`: updated on authenticated use.

State transitions:

```text
Issued → Active → Revoked
                 ↘ Expired
```

A token is accepted only while not revoked or expired and while its user and membership remain active.

## New entity

### LoginAttempt

Tracks consecutive failed sign-in attempts for one normalized username so throttling is consistent across backend workers.

- `normalized_username`: unique, normalized username key; do not store the submitted password.
- `failed_attempts`: consecutive failed attempts in the current window.
- `locked_until`: optional end time of the temporary 15-minute retry limit.
- `updated_at`: used to determine whether an expired window can be reset.

Validation and lifecycle:

- A failed credential check increments `failed_attempts`.
- Once the fifth consecutive failure is reached, set `locked_until` to 15 minutes after the threshold is reached.
- During the active cooldown, reject authentication without checking the password and provide retry timing.
- On successful authentication or after cooldown expiry, clear the count and cooldown.
- Unknown usernames follow the same failure counting and invalid-credential response as known usernames.
- Old, unlocked attempt records may be removed by routine cleanup; cleanup timing is an implementation detail.

## Relationships

- A User has many ApiTokens and LoginAttempts are keyed by normalized username rather than a foreign key, allowing unknown usernames to be throttled without disclosing account existence.
- An ApiToken belongs to one User, Account, and Membership.
