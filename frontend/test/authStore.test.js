import assert from 'node:assert/strict'
import { afterEach, beforeEach, test } from 'node:test'
import { createPinia, setActivePinia } from 'pinia'
import { useAuthStore } from '../src/modules/auth/stores/authStore.js'

const originalFetch = globalThis.fetch

beforeEach(() => {
  setActivePinia(createPinia())
})

afterEach(() => {
  globalThis.fetch = originalFetch
})

test('sign-out clears auth state only after the API confirms success', async () => {
  let request
  globalThis.fetch = async (url, options) => {
    request = { url, options }
    return new globalThis.Response(null, { status: 204 })
  }
  const auth = useAuthStore()
  auth.user = { id: 'user-1' }
  auth.account = { id: 'account-1' }
  auth.membership = { role: 'owner' }

  assert.equal(await auth.submitSignOut(), true)
  assert.equal(request.url, '/api/v1/session')
  assert.equal(request.options.method, 'DELETE')
  assert.equal(request.options.credentials, 'include')
  assert.equal(auth.user, null)
  assert.equal(auth.account, null)
  assert.equal(auth.membership, null)
})

test('sign-out keeps auth state when the API request fails', async () => {
  globalThis.fetch = async () => {
    throw new Error('offline')
  }
  const auth = useAuthStore()
  const user = { id: 'user-1' }
  const account = { id: 'account-1' }
  const membership = { role: 'owner' }
  auth.user = user
  auth.account = account
  auth.membership = membership

  assert.equal(await auth.submitSignOut(), false)
  assert.deepEqual(auth.user, user)
  assert.deepEqual(auth.account, account)
  assert.deepEqual(auth.membership, membership)
  assert.match(auth.error, /kết nối máy chủ/i)
  assert.equal(auth.pending, false)
})
