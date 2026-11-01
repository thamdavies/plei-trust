# Research: User Login and Logout

## Decision 1: Reuse the existing session and current-user endpoints

- **Decision**: Keep the existing `POST /api/v1/session`, `DELETE /api/v1/session`, and `GET /api/v1/me` routes as the browser authentication contract. Extend the existing session token flow only where needed for browser session persistence and temporary login throttling.
- **Rationale**: The Rails backend already verifies active users and memberships, issues revocable `ApiToken` records, protects API endpoints with bearer tokens, and exposes a current-user endpoint. Reusing these behaviors avoids a second identity/session system.
- **Alternatives considered**: Add a separate browser-only login resource or replace API tokens with Rails server sessions. Both duplicate or replace working authentication behavior without a user requirement.

## Decision 2: Deliver the browser token in a secure cookie

- **Decision**: Return the raw API token only as an `HttpOnly`, `Secure` in production, `SameSite=Lax` cookie whose expiry matches the token's expiry. The frontend sends credentialed requests; API authentication accepts the cookie for the browser while preserving existing bearer-token support for non-browser API callers. Logout revokes the token and clears the cookie. Restrict credentialed cross-origin access to configured frontend origins and require same-origin protections for state-changing cookie-authenticated requests.
- **Rationale**: The spec requires a session to survive page reloads. An `HttpOnly` cookie supports that behavior without exposing a bearer token to JavaScript-readable browser storage. Keeping bearer support avoids breaking current API consumers.
- **Alternatives considered**: `localStorage` is simpler but exposes a long-lived bearer token to JavaScript and any successful cross-site scripting. `sessionStorage` survives reloads but ends the session when the tab closes, which is shorter than the clarified session behavior.

## Decision 3: Track failed sign-ins by normalized username

- **Decision**: Persist consecutive failed attempts for the normalized username. After five failures, reject further login attempts for 15 minutes; reset the count on successful authentication and after the cooldown expires. Return the same invalid-credentials response for unknown users and incorrect passwords; return a distinct temporary-limit response only once the limit is reached.
- **Rationale**: The clarified requirement specifies a fixed threshold and cooldown. A durable record keeps the limit consistent across application processes and restarts. Normalizing the username matches the existing user lookup behavior.
- **Alternatives considered**: In-memory counters are not reliable across multiple workers or restarts. Permanent account locking was explicitly rejected by the user.

## Decision 4: Organize the frontend as a modular monolith

- **Decision**: Keep one frontend application and build, organized into business modules with explicit public entry points. Place authentication UI, routes, state, and API operations inside `modules/auth`; place the existing dashboard in `modules/dashboard`; keep app bootstrap and route composition in `app`; put generic HTTP transport and reusable UI primitives in `shared`. The auth module owns signed-in user/account state, sign-in, sign-out, and current-user restoration, and exports route registration and a small public auth interface.
- **Dependency rules**: `app` composes modules; a feature module may depend on `shared` and its own files; modules must not import another module's internal files. Cross-module behavior goes through the exporting module's public entry point. `shared` must not depend on business modules. Keep the existing single Vue app and deployment artifact.
- **Rationale**: The frontend already uses Vue, Pinia, and Vue Router. Module boundaries keep authentication behavior cohesive and let the dashboard and future business areas evolve independently without splitting deployment or introducing service-to-service complexity.
- **Alternatives considered**: A flat `components/views/stores/services` structure makes business behavior spread across generic folders. Separate frontend applications or micro-frontends add deployment and integration complexity that the current product does not need.

## Decision 5: Use the existing app test conventions and document end-to-end validation

- **Decision**: Add backend Minitest coverage for session endpoints, throttling, and cookie/token lifecycle; add frontend coverage using the project's available test setup if present, otherwise validate the frontend through build/lint and the runnable browser scenarios in `quickstart.md`.
- **Rationale**: The backend project uses Minitest and the frontend currently declares build/lint scripts but no test runner. The plan avoids introducing a new frontend test dependency solely for this feature.
- **Alternatives considered**: Adding a new frontend test framework expands dependencies and setup beyond the established project without existing frontend tests.

## Open integration assumptions resolved for planning

- The API and frontend can be configured to use a same-site origin in production. If deployed on separate sites, cookie and cross-origin browser rules require an explicit deployment decision before implementation.
- The existing token lifetime remains the session lifetime (currently 12 hours by default, configurable with `TOKEN_TTL_HOURS`).
- The server will return a `Retry-After` value with the temporary login-limit response so the frontend can tell the user when to retry.
