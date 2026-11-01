# Implementation Plan: User Login and Logout

**Branch**: `003-user-auth` | **Date**: 2026-11-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/003-user-auth/spec.md`

## Summary

Add a Vue sign-in flow, persistent authenticated routing, and sign-out using the existing Rails session and current-user API. Reuse revocable API tokens, deliver the browser token through an HttpOnly cookie aligned with the existing token expiry, and add durable per-username throttling after five consecutive failed attempts for 15 minutes.

## Technical Context

**Language/Version**: Ruby 3.x (backend; repository runtime) and JavaScript ES modules (frontend; Node runtime as configured by the repository)

**Primary Dependencies**: Rails API, Jbuilder, Minitest, Vue 3, Pinia, Vue Router, Vite

**Storage**: Existing relational database for users, memberships, accounts, and API tokens; add a login-attempts table.

**Testing**: Backend Minitest; frontend Node unit tests, lint/build, and Playwright browser E2E tests against the Rails test environment.

**Target Platform**: Web browser, Rails API server, and relational database.

**Project Type**: Web application with separate `backend/` and `frontend/` projects.

**Performance Goals**: Under 30 seconds for the complete sign-in journey under normal service conditions; user feedback while requests are in progress.

**Constraints**: Preserve existing bearer-token API support; cookie-authenticated state-changing requests must use same-site/CSRF protections; never store passwords or raw token values in the database; five failures lead to a 15-minute limit, never permanent account lock.

**Scale/Scope**: Existing Pawnify account and membership model; one browser sign-in screen and protected route group; no registration or password recovery.

## Constitution Check

The checked-in constitution is still the unfilled Spec Kit template and contains no ratified project principles or enforceable gates. Apply the project conventions documented in existing code and design records:

- **Status**: Pass, with no constitutional violations identified.
- Reuse Rails controllers, models, Jbuilder views, and Minitest in the backend.
- Reuse Vue, Pinia, Vue Router, and Tailwind utility styling in the frontend; organize frontend source as one modular monolith with business modules and explicit public entry points.
- Preserve the existing API token/revocation model and explicit account-membership authorization.
- Keep the authentication API contract versioned under `/api/v1`.

## Project Structure

### Documentation (this feature)

```text
specs/003-user-auth/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
    └── auth-api.yaml
```

### Source Code (repository root)

```text
backend/
├── app/controllers/api/v1/       # Extend session and current-user behavior
├── app/controllers/concerns/     # Cookie and bearer authentication behavior
├── app/models/                   # LoginAttempt and existing ApiToken/User models
├── app/views/api/v1/             # Session/current-user/error JSON views
├── config/routes.rb              # Existing singleton session/me routes
├── db/migrate/                   # Login attempts storage
└── test/                          # Controller, model, and integration coverage

frontend/
└── src/
    ├── main.js                   # Vite entry point; mounts the app composition
    ├── app/                      # Root app shell and composition of module routes
    ├── modules/
    │   ├── auth/                 # Sign-in, auth state/API, route guard, public exports
    │   └── dashboard/            # Dashboard view, dashboard state, public exports
    └── shared/
        ├── api/                  # Generic credentialed HTTP transport and error mapping
        └── ui/                   # Reusable presentation primitives
```

**Structure Decision**: Keep the existing two-project layout and one frontend app/build. Organize frontend by business capability rather than placing feature code into global technical buckets. `app` composes modules, `auth` owns authentication behavior, and `shared` contains only business-agnostic infrastructure and UI. Modules consume another module only through its public entry point; `shared` never imports business modules. Move existing router, dashboard view, and dashboard store into their corresponding module/app boundaries as part of implementation. Do not create another service. Use Playwright Test for browser-level authentication coverage, with a dedicated test-only Rails server and seeded test database.

## Complexity Tracking

No constitution gates are violated; no exception is needed.
