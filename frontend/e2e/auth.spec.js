import { expect, test } from '@playwright/test'

test.describe.serial('authentication in the browser', () => {
  async function submitAndWaitForStatus(page, status) {
    const responsePromise = page.waitForResponse(
      (response) => response.url().endsWith('/api/v1/session') && response.status() === status,
    )
    await page.getByRole('button', { name: 'Đăng nhập' }).click()
    await responsePromise
  }

  test('uses Vue validation instead of native HTML validation', async ({ page }) => {
    await page.goto('/sign-in')
    const form = page.locator('form')

    await expect(form).toHaveAttribute('novalidate', '')
    await page.getByRole('button', { name: 'Đăng nhập' }).click()

    await expect(page.getByText('Vui lòng nhập tên đăng nhập.')).toBeVisible()
    await expect(page.getByText('Vui lòng nhập mật khẩu.')).toBeVisible()
  })

  test('rejects invalid credentials with generic feedback', async ({ page }) => {
    await page.goto('/sign-in')
    await page.getByLabel('Tên đăng nhập').fill(`missing-${Date.now()}`)
    await page.getByLabel('Mật khẩu').fill('incorrect')
    await page.getByRole('button', { name: 'Đăng nhập' }).click()

    await expect(page.getByRole('alert')).toContainText('Tên đăng nhập hoặc mật khẩu không đúng.')
    await expect(page).toHaveURL(/\/sign-in$/)
  })

  test('restores the cookie session after reload and signs out from the account menu', async ({
    page,
  }) => {
    await page.goto('/sign-in')
    await page.getByLabel('Tên đăng nhập').fill('admin')
    await page.getByLabel('Mật khẩu').fill(process.env.E2E_ADMIN_PASSWORD || '12345678')
    const signInResponsePromise = page.waitForResponse(
      (response) =>
        response.request().method() === 'POST' && response.url().endsWith('/api/v1/session'),
    )
    await page.getByRole('button', { name: 'Đăng nhập' }).click()
    const signInResponse = await signInResponsePromise

    expect(signInResponse.status()).toBe(201)
    expect((await signInResponse.headerValue('set-cookie'))?.includes('pawnify_session=')).toBe(
      true,
    )
    await expect(page).toHaveURL('/')
    await expect(page.getByRole('button', { name: 'Thông tin tài khoản' })).toBeVisible()
    const sessionCookie = (await page.context().cookies()).find(
      (cookie) => cookie.name === 'pawnify_session',
    )
    expect(sessionCookie).toMatchObject({ httpOnly: true, sameSite: 'Lax' })
    expect(await page.evaluate(() => Object.keys(localStorage))).not.toContain('pawnify_session')
    await page.reload()
    await expect(page.getByRole('button', { name: 'Thông tin tài khoản' })).toBeVisible()

    await page.getByRole('button', { name: 'Thông tin tài khoản' }).click()
    await expect(page.getByRole('menu', { name: 'Menu tài khoản' })).toBeVisible()
    await page.getByRole('menuitem', { name: 'Đăng xuất' }).click()

    await expect(page).toHaveURL(/\/sign-in$/)
    await page.goto('/')
    await expect(page).toHaveURL(/\/sign-in$/)
  })

  test('temporarily limits login after five consecutive failures', async ({ page }) => {
    await page.goto('/sign-in')
    await page.getByLabel('Tên đăng nhập').fill('admin')
    await page.getByLabel('Mật khẩu').fill('incorrect')

    for (let attempt = 0; attempt < 5; attempt += 1) {
      await submitAndWaitForStatus(page, 401)
      await expect(page.getByRole('alert')).toContainText('Tên đăng nhập hoặc mật khẩu không đúng.')
    }

    await submitAndWaitForStatus(page, 429)
    await expect(page.getByRole('alert')).toContainText('Bạn đã thử quá nhiều lần.')
    await expect(page.getByRole('button', { name: /Thử lại sau/ })).toBeDisabled()
  })
})
