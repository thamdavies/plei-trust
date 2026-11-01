import { createRouter, createWebHistory } from 'vue-router'
import { authRoutes, authRouteGuard, useAuthStore } from '../modules/auth'
import { dashboardRoutes } from '../modules/dashboard'
import { createPinia } from 'pinia'

export const pinia = createPinia()

const router = createRouter({
  history: createWebHistory(),
  routes: [...authRoutes, ...dashboardRoutes],
})

router.beforeEach((to) => authRouteGuard(to, useAuthStore(pinia)))

export default router
