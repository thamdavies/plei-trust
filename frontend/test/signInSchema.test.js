import assert from 'node:assert/strict'
import { test } from 'node:test'
import { signInZodSchema } from '../src/modules/auth/validation/signInSchema.js'

test('login validation requires a non-empty username and password', () => {
  const result = signInZodSchema.safeParse({ username: '   ', password: '' })

  assert.equal(result.success, false)
  assert.deepEqual(
    result.error.issues.map(({ path, message }) => ({ path: path[0], message })),
    [
      { path: 'username', message: 'Vui lòng nhập tên đăng nhập.' },
      { path: 'password', message: 'Vui lòng nhập mật khẩu.' },
    ],
  )
})

test('login validation trims the username before submission', () => {
  const result = signInZodSchema.safeParse({ username: '  admin  ', password: 'secret' })

  assert.equal(result.success, true)
  assert.deepEqual(result.data, { username: 'admin', password: 'secret' })
})
