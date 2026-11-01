import assert from 'node:assert/strict'
import { test } from 'node:test'
import { authRouteGuard } from '../src/modules/auth/routeGuard.js'

function fakeAuth(values = {}) {
  return {
    initialized: true,
    user: null,
    restores: 0,
    async restoreSession() {
      this.restores += 1
      this.initialized = true
    },
    ...values,
  }
}

test('protected routes restore the session and redirect signed-out users', async () => {
  const auth = fakeAuth({ initialized: false })
  const result = await authRouteGuard({ meta: { requiresAuth: true }, name: 'dashboard' }, auth)

  assert.deepEqual(result, { name: 'sign-in' })
  assert.equal(auth.restores, 1)
})

test('signed-in users are redirected away from the sign-in page', async () => {
  const auth = fakeAuth({ user: { id: 'user-1' } })
  const result = await authRouteGuard({ meta: {}, name: 'sign-in' }, auth)

  assert.deepEqual(result, { name: 'dashboard' })
})

test('authenticated protected routes proceed after session restoration', async () => {
  const auth = fakeAuth({ initialized: false, user: { id: 'user-1' } })
  const result = await authRouteGuard({ meta: { requiresAuth: true }, name: 'dashboard' }, auth)

  assert.equal(result, true)
  assert.equal(auth.restores, 1)
})

test('public routes proceed without authentication', async () => {
  const auth = fakeAuth()
  const result = await authRouteGuard({ meta: {}, name: 'sign-in' }, auth)

  assert.equal(result, true)
  assert.equal(auth.restores, 0)
})
