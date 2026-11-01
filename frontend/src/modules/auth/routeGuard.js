export async function authRouteGuard(to, auth) {
  if (!auth.initialized) await auth.restoreSession()
  if (to.meta.requiresAuth && !auth.user) return { name: 'sign-in' }
  if (to.name === 'sign-in' && auth.user) return { name: 'dashboard' }
  return true
}
