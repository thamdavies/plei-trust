---

description: "Actionable implementation tasks for user login and logout"
---

# Tasks: User Login and Logout

**Input**: Design documents from `/specs/003-user-auth/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/auth-api.yaml`, `quickstart.md`

**Tests**: Backend Minitest integration coverage is maintained in `backend/test/controllers/api/v1/sessions_controller_test.rb` for cookie revocation, missing sessions, rejected origins, and bearer-token logout. Frontend auth-store logout behavior is covered by the built-in Node test runner in `frontend/test/authStore.test.js`; frontend lint/build checks and the browser scenarios in `quickstart.md` cover the remaining integration.

**Organization**: Tasks are grouped by user story. The frontend remains one application and build, organized as a modular monolith with explicit module entry points.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the frontend modular-monolith boundaries while keeping the existing Vite entry point.

- [X] T001 [P] Create the app shell and route composition in `frontend/src/app/App.vue` and `frontend/src/app/router.js`, and mount them from `frontend/src/main.js`.
- [X] T002 [P] Move the existing dashboard view and Pinia store into `frontend/src/modules/dashboard/views/DashboardView.vue` and `frontend/src/modules/dashboard/stores/dashboardStore.js`, and export dashboard routes through `frontend/src/modules/dashboard/index.js`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Provide shared browser/API transport and credentialed cookie access before implementing stories.

- [X] T003 Create the shared credentialed JSON client in `frontend/src/shared/api/httpClient.js`; read `VITE_API_BASE_URL`, include browser credentials, normalize API errors, and handle unauthorized responses.
- [X] T004 Configure credentialed browser requests and an explicit frontend-origin allow-list in `backend/config/initializers/cors.rb`; allow only the methods and headers required by the session and current-user contract.

**Checkpoint**: The modular app shell and shared browser/API boundary are ready for feature modules.

---

## Phase 3: User Story 1 - Sign in (Priority: P1) 🎯 MVP

**Goal**: Let an existing user sign in, restore the session across reloads, and receive safe feedback for invalid or temporarily limited attempts.

**Independent Test**: Submit valid credentials and reach the protected dashboard; reload and remain signed in. Invalid credentials keep the user signed out, and the sixth consecutive failure is temporarily limited for 15 minutes.

### Implementation for User Story 1

- [X] T005 [US1] [P] Add `backend/db/migrate/20261101160000_create_login_attempts.rb` to create login attempts with a unique normalized username, failed-attempt count, optional `locked_until`, and timestamps.
- [X] T006 [US1] [P] Add `backend/app/models/login_attempt.rb` with normalized-username lookup, consecutive-failure tracking, 5-failure/15-minute cooldown, reset after successful authentication or cooldown expiry, and no stored password.
- [X] T007 [US1] Add the temporary sign-in limit to `backend/app/controllers/api/v1/sessions_controller.rb`; return the generic invalid-credentials response for unknown users and incorrect passwords, and return the temporary-limit response with `Retry-After` only during cooldown.
- [X] T008 [US1] Extend `backend/app/controllers/concerns/authentication.rb` and `backend/app/controllers/api/v1/sessions_controller.rb` to issue/read the `pawnify_session` cookie with `HttpOnly`, `SameSite=Lax`, production `Secure`, and expiry matching the API token while preserving bearer-token authentication.
- [X] T009 [US1] Update `backend/app/views/api/v1/sessions/create.json.jbuilder` and `backend/app/views/api/v1/shared/error.json.jbuilder` to match `specs/003-user-auth/contracts/auth-api.yaml` and keep the raw token out of JSON responses.
- [X] T010 [US1] [P] Add `frontend/src/modules/auth/api/authApi.js` for `POST /session` and `GET /me` using `frontend/src/shared/api/httpClient.js`; expose typed-by-convention success and error shapes to the auth module.
- [X] T011 [US1] Implement session restoration, sign-in state, pending state, retry timing, and signed-in user/account state in `frontend/src/modules/auth/stores/authStore.js`.
- [X] T012 [US1] Create the Vietnamese sign-in form in `frontend/src/modules/auth/views/SignInPage.vue` using Tailwind utilities; validate required fields, disable duplicate submissions, and display generic credential, service, and retry-limit feedback.
- [X] T013 [US1] Export auth routes from `frontend/src/modules/auth/index.js` and integrate them into `frontend/src/app/router.js`; restore the session before protected navigation, redirect signed-out users to sign-in, and send signed-in users to the dashboard.

**Checkpoint**: User Story 1 works independently: sign-in, page-reload restoration, protected routing, invalid-credential feedback, and temporary limiting.

---

## Phase 4: User Story 2 - Sign out (Priority: P1)

**Goal**: Let an authenticated user revoke their session and return to a signed-out state.

**Independent Test**: Sign in, choose sign out, and confirm protected routes require sign-in afterward. If the sign-out request fails, the UI reports the failure and does not claim that the session ended.

**Dependency**: Requires the cookie authentication and auth store from User Story 1.

### Implementation for User Story 2

- [X] T014 [P] [US2] Make `DELETE /api/v1/session` accept the browser cookie, revoke the active `ApiToken`, and clear the cookie only after successful revocation in `backend/app/controllers/api/v1/sessions_controller.rb`.
- [X] T015 [P] [US2] Add sign-out to `frontend/src/modules/auth/stores/authStore.js`; clear client auth state and navigate only after the API confirms success, while preserving a retryable error state on failure.
- [X] T016 [US2] Add an authenticated-user sign-out control in `frontend/src/modules/auth/components/SignOutButton.vue` and export it through `frontend/src/modules/auth/index.js`.
- [X] T017 [US2] Integrate the public sign-out control into `frontend/src/modules/dashboard/views/DashboardView.vue` without importing auth-module internals.

**Checkpoint**: User Stories 1 and 2 work independently and the signed-out state cannot access protected dashboard routes.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Keep the implementation guidance aligned with the final interface and module boundaries.

- [X] T018 Reconcile the implemented cookie attributes, response/error shapes, retry behavior, module entry points, and browser scenarios in `specs/003-user-auth/contracts/auth-api.yaml` and `specs/003-user-auth/quickstart.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; T001 and T002 can run in parallel because they own separate files and agree on the dashboard module entry point.
- **Foundational (Phase 2)**: Depends on Phase 1; T003 and T004 can run in parallel.
- **User Story 1 (Phase 3)**: Depends on Phase 2. T005 and T006 can run in parallel. T007 depends on T006. T008 follows T007 because both update the session controller; T009 can proceed in parallel with backend controller work after the contract is understood. T010 can proceed alongside backend work. T011 depends on T010; T012 depends on T011; T013 integrates the completed auth module with app routing.
- **User Story 2 (Phase 4)**: Depends on User Story 1 cookie authentication and auth store. T014 and T015 can proceed in parallel against the agreed API contract; T016 depends on the store action in T015, and T017 depends on the public control in T016.
- **Polish (Phase 5)**: Depends on both user stories.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after shared app/API foundations; delivers the MVP sign-in and protected-session flow.
- **User Story 2 (P1)**: Follows User Story 1 because it uses the established browser session and auth store.

### Parallel Opportunities

- T001 with T002.
- T003 with T004.
- T005 with T006.
- T010 can proceed in parallel with backend tasks T005-T009 after the contract is agreed.
- Backend API work and isolated frontend auth API work can proceed in parallel; store, view, and route integration remain ordered by their dependencies.
- In User Story 2, T014 and T015 can proceed in parallel because they update separate backend and frontend files; T016 and T017 remain sequential.

---

## Parallel Example: Setup

```text
Task: T001 Create the app shell and route composition in frontend/src/app/...
Task: T002 Move the dashboard into frontend/src/modules/dashboard/...
```

## Parallel Example: User Story 1

```text
Task: T005 Create the login-attempt migration in backend/db/migrate/...
Task: T006 Create the LoginAttempt model in backend/app/models/login_attempt.rb
Task: T010 Add the frontend session API wrapper in frontend/src/modules/auth/api/authApi.js
```

## Parallel Example: User Story 2

```text
Task: T014 Implement cookie-backed API sign-out in backend/app/controllers/api/v1/sessions_controller.rb
Task: T015 Implement the frontend sign-out store action in frontend/src/modules/auth/stores/authStore.js
```

## Implementation Strategy

### MVP First (User Story 1)

1. Complete setup and foundational phases.
2. Complete User Story 1, including the session cookie, session restoration, route protection, and failed-attempt limit.
3. Validate the User Story 1 independent criteria in `specs/003-user-auth/quickstart.md`.
4. Implement User Story 2 sign-out and its failure behavior.

### Incremental Delivery

1. Finish the modular frontend shell and shared API boundary.
2. Deliver sign-in as the first usable increment.
3. Add sign-out as the second increment, reusing the session and auth module.
4. Reconcile the contract and quickstart after implementation.

## Browser E2E Coverage

- [X] T019 Add a pinned Playwright Test runner, Chromium configuration, and root/frontend `test:e2e` scripts.
- [X] T020 Add browser scenarios for Vue validation, generic invalid-credential feedback, login, cookie-session restoration, account-menu logout, protected-route redirection, and temporary throttling.
- [X] T021 Add a test-only Rails server bootstrap that prepares and seeds `pawnify_test`, clears login-attempt state, and document E2E setup and execution.

## Notes

- Every task uses the required checkbox, sequential task ID, optional `[P]`, story label for user-story tasks, and concrete file paths.
- Backend and frontend unit/integration tests complement the browser E2E scenarios documented in `quickstart.md`.
- Frontend modules import another module only through its public `index.js`; `shared` does not depend on business modules.
