import { computed, ref } from 'vue'
import { defineStore } from 'pinia'
import { getCurrentUser, signIn, signOut } from '../api/authApi.js'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const account = ref(null)
  const membership = ref(null)
  const initialized = ref(false)
  const pending = ref(false)
  const error = ref('')
  const retryUntil = ref(null)
  const retryTick = ref(Date.now())
  const retryTicker = setInterval(() => { retryTick.value = Date.now() }, 1000)
  retryTicker.unref?.()
  const retrySeconds = computed(() => {
    retryTick.value
    return Math.max(0, Math.ceil((retryUntil.value - Date.now()) / 1000))
  })

  async function restoreSession() {
    try {
      const context = await getCurrentUser()
      user.value = context.user
      account.value = context.account
      membership.value = context.membership
    } catch {
      user.value = null
      account.value = null
      membership.value = null
    } finally {
      initialized.value = true
    }
  }

  async function submitSignIn(credentials) {
    pending.value = true
    error.value = ''
    try {
      const context = await signIn(credentials)
      user.value = context.user
      account.value = context.account
      membership.value = context.membership
      retryUntil.value = null
      return true
    } catch (cause) {
      if (cause.status === 401) error.value = 'Tên đăng nhập hoặc mật khẩu không đúng.'
      else if (cause.status === 429) {
        const seconds = cause.retryAfter || 900
        retryUntil.value = Date.now() + seconds * 1000
        error.value = `Bạn đã thử quá nhiều lần. Vui lòng thử lại sau ${Math.ceil(seconds / 60)} phút.`
      } else error.value = cause.message || 'Không thể đăng nhập lúc này. Vui lòng thử lại.'
      return false
    } finally {
      pending.value = false
    }
  }

  async function submitSignOut() {
    pending.value = true
    error.value = ''
    try {
      await signOut()
      user.value = null
      account.value = null
      membership.value = null
      return true
    } catch (cause) {
      error.value = cause.message || 'Không thể đăng xuất. Vui lòng thử lại.'
      return false
    } finally {
      pending.value = false
    }
  }

  return { user, account, membership, initialized, pending, error, retryUntil, retrySeconds, restoreSession, submitSignIn, submitSignOut }
})
