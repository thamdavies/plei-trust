import assert from 'node:assert/strict'
import { afterEach, beforeEach, test } from 'node:test'
import { createPinia, setActivePinia } from 'pinia'
import { useAuthStore } from '../src/modules/auth/stores/authStore.js'

const originalFetch = globalThis.fetch
const sessionContext = {
  user: { id: 'user-1', username: 'admin' },
  account: { id: 'account-1', name: 'Pawnify' },
  membership: { role: 'owner' },
}

function jsonResponse(status, body, headers = {}) {
  return new globalThis.Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...headers },
  })
}

beforeEach(() => {
  setActivePinia(createPinia())
})

afterEach(() => {
  globalThis.fetch = originalFetch
})

test('sign-in sends credentialed JSON and stores the returned session context', async () => {
  let request
  globalThis.fetch = async (url, options) => {
    request = { url, options }
    return jsonResponse(201, sessionContext)
  }
  const auth = useAuthStore()

  assert.equal(await auth.submitSignIn({ username: 'admin', password: 'secret' }), true)
  assert.equal(request.url, '/api/v1/session')
  assert.equal(request.options.method, 'POST')
  assert.equal(request.options.credentials, 'include')
  assert.equal(request.options.headers['Content-Type'], 'application/json')
  assert.deepEqual(JSON.parse(request.options.body), { username: 'admin', password: 'secret' })
  assert.deepEqual(auth.user, sessionContext.user)
  assert.deepEqual(auth.account, sessionContext.account)
  assert.deepEqual(auth.membership, sessionContext.membership)
  assert.equal(auth.pending, false)
  assert.equal(auth.error, '')
})

test('sign-in shows the same generic message for rejected credentials', async () => {
  globalThis.fetch = async () => jsonResponse(401, {
    error: { code: 'invalid_credentials', message: 'Username or password is incorrect' },
  })
  const auth = useAuthStore()

  assert.equal(await auth.submitSignIn({ username: 'unknown', password: 'secret' }), false)
  assert.equal(auth.user, null)
  assert.equal(auth.error, 'Tên đăng nhập hoặc mật khẩu không đúng.')
  assert.equal(auth.pending, false)
})

test('sign-in preserves retry timing returned by the temporary limit', async () => {
  globalThis.fetch = async () => jsonResponse(
    429,
    { error: { code: 'temporarily_limited', message: 'Too many attempts' } },
    { 'Retry-After': '120' },
  )
  const auth = useAuthStore()
  const before = Date.now()

  assert.equal(await auth.submitSignIn({ username: 'admin', password: 'secret' }), false)
  assert.ok(auth.retryUntil >= before + 120_000)
  assert.ok(auth.retrySeconds > 0)
  assert.match(auth.error, /2 phút/)
})

test('sign-in reports server failures without claiming success', async () => {
  globalThis.fetch = async () => jsonResponse(503, {
    error: { code: 'service_unavailable', message: 'Dịch vụ đang bảo trì.' },
  })
  const auth = useAuthStore()

  assert.equal(await auth.submitSignIn({ username: 'admin', password: 'secret' }), false)
  assert.equal(auth.user, null)
  assert.equal(auth.error, 'Dịch vụ đang bảo trì.')
})

test('session restoration loads the current user from the cookie-backed API', async () => {
  let request
  globalThis.fetch = async (url, options) => {
    request = { url, options }
    return jsonResponse(200, sessionContext)
  }
  const auth = useAuthStore()

  await auth.restoreSession()

  assert.equal(request.url, '/api/v1/me')
  assert.equal(request.options.method, 'GET')
  assert.equal(request.options.credentials, 'include')
  assert.deepEqual(auth.user, sessionContext.user)
  assert.deepEqual(auth.account, sessionContext.account)
  assert.deepEqual(auth.membership, sessionContext.membership)
  assert.equal(auth.initialized, true)
})

test('session restoration clears stale client state after an unauthorized response', async () => {
  globalThis.fetch = async () => jsonResponse(401, {
    error: { code: 'unauthorized', message: 'Authentication required' },
  })
  const auth = useAuthStore()
  auth.user = sessionContext.user
  auth.account = sessionContext.account
  auth.membership = sessionContext.membership

  await auth.restoreSession()

  assert.equal(auth.user, null)
  assert.equal(auth.account, null)
  assert.equal(auth.membership, null)
  assert.equal(auth.initialized, true)
})

test('session restoration handles a network failure as signed out', async () => {
  globalThis.fetch = async () => { throw new Error('offline') }
  const auth = useAuthStore()

  await auth.restoreSession()

  assert.equal(auth.user, null)
  assert.equal(auth.initialized, true)
})

test('sign-out clears auth state only after the API confirms success', async () => {
  let request
  globalThis.fetch = async (url, options) => {
    request = { url, options }
    return new globalThis.Response(null, { status: 204 })
  }
  const auth = useAuthStore()
  auth.user = sessionContext.user
  auth.account = sessionContext.account
  auth.membership = sessionContext.membership

  assert.equal(await auth.submitSignOut(), true)
  assert.equal(request.url, '/api/v1/session')
  assert.equal(request.options.method, 'DELETE')
  assert.equal(request.options.credentials, 'include')
  assert.equal(auth.user, null)
  assert.equal(auth.account, null)
  assert.equal(auth.membership, null)
})

test('sign-out keeps auth state when the API request fails', async () => {
  globalThis.fetch = async () => { throw new Error('offline') }
  const auth = useAuthStore()
  auth.user = sessionContext.user
  auth.account = sessionContext.account
  auth.membership = sessionContext.membership

  assert.equal(await auth.submitSignOut(), false)
  assert.deepEqual(auth.user, sessionContext.user)
  assert.deepEqual(auth.account, sessionContext.account)
  assert.deepEqual(auth.membership, sessionContext.membership)
  assert.match(auth.error, /kết nối máy chủ/i)
  assert.equal(auth.pending, false)
})
