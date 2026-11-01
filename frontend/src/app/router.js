import { createRouter, createWebHistory } from 'vue-router'
import { authRoutes, useAuthStore } from '../modules/auth'
import { dashboardRoutes } from '../modules/dashboard'
import { createPinia } from 'pinia'

export const pinia = createPinia()

const router = createRouter({
  history: createWebHistory(),
  routes: [...authRoutes, ...dashboardRoutes],
})

router.beforeEach(async (to) => {
  const auth = useAuthStore(pinia)
  if (!auth.initialized) await auth.restoreSession()
  if (to.meta.requiresAuth && !auth.user) return { name: 'sign-in' }
  if (to.name === 'sign-in' && auth.user) return { name: 'dashboard' }
  return true
})

export default router
