# Quickstart: Validate User Login and Logout

## Prerequisites

- Ruby/backend dependencies and database are configured for the repository.
- Frontend dependencies are installed.
- A seeded active user has an active account membership with account-scoped access.
- Backend and frontend origins are configured so browser requests can send the session cookie. Set `FRONTEND_ORIGINS` to the exact frontend origin(s); production frontend and API origins must remain same-site for the `SameSite=Lax` cookie.

## Run the applications

1. Start the backend using the repository's Rails development command from `backend/`.
2. Start the frontend using `npm run dev` from `frontend/`.
3. Open the frontend URL printed by Vite.

## Validation scenarios

1. **Sign in**: Submit a valid username and password. Expect navigation to the authenticated dashboard and no token exposed in page JavaScript or browser local storage.
2. **Restore after reload**: Reload the dashboard. Expect the current-user request to restore the authenticated view without showing the sign-in page.
3. **Invalid credentials**: Submit an incorrect password. Expect a clear generic error and remain signed out.
4. **Temporary limit**: Submit invalid credentials five times. Those attempts receive the generic credential error; the following attempt is temporarily rejected with a retry time of about 15 minutes. After the cooldown, sign-in is available again and no permanent account lock remains.
5. **Sign out**: Use the sign-out action. Expect the app to clear authenticated state, revoke the session, and return to sign-in.
6. **Protected navigation**: After sign-out or token expiry, open a protected route directly. Expect redirection to sign-in and no protected data to be displayed.
7. **Service failure**: Stop the backend and try sign-in or sign-out. Expect a recoverable error and no false success state.

## Automated checks

- Backend: run the auth integration tests with `bin/rails test test/controllers/api/v1/sessions_controller_test.rb test/controllers/api/v1/me_controller_test.rb`, then the full backend suite with `bin/rails test`.
- Frontend: run `npm test`, `npm run lint`, and `npm run build` from `frontend/`.
- Browser E2E: make the test PostgreSQL database available, then run `pnpm test:e2e` from the repository root. Playwright prepares and seeds only `pawnify_test`, clears its login-attempt records, and starts the Rails test server and Vite on `127.0.0.1:3100` and `127.0.0.1:5174`. Set `E2E_ADMIN_PASSWORD` if the test admin uses a password other than the seed default `12345678`. Install the browser once with `pnpm --filter pawnify-dashboard exec playwright install chromium`.
- API contract: compare the session and current-user responses, status codes, cookie behavior, and retry header with [`contracts/auth-api.yaml`](contracts/auth-api.yaml).
