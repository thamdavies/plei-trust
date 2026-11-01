import SignInPage from './views/SignInPage.vue'

export const authRoutes = [
  { path: '/sign-in', name: 'sign-in', component: SignInPage },
  { path: '/:pathMatch(.*)*', redirect: '/' },
]

export { default as SignOutButton } from './components/SignOutButton.vue'
export { useAuthStore } from './stores/authStore'
