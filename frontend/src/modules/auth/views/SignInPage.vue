<script setup>
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/authStore'

const auth = useAuthStore()
const router = useRouter()
const username = ref('')
const password = ref('')
const canSubmit = computed(() => !auth.pending && auth.retrySeconds === 0)

async function submit() {
  if (!username.value.trim() || !password.value) return
  if (await auth.submitSignIn({ username: username.value, password: password.value })) {
    await router.replace({ name: 'dashboard' })
  }
}
</script>

<template>
  <main class="min-h-screen grid place-items-center bg-[#f5f7f5] p-5 text-[#27352d]">
    <section class="w-full max-w-md rounded-2xl border border-[#e4e9e4] bg-white p-8 shadow-[0_14px_45px_#1b342312]">
      <div class="mb-8">
        <p class="mb-2 text-sm font-bold uppercase tracking-[0.18em] text-[#66816d]">Pawnify</p>
        <h1 class="m-0 text-2xl font-bold">Đăng nhập</h1>
        <p class="mt-2 text-sm text-[#78857b]">Đăng nhập để tiếp tục quản lý cửa hàng của bạn.</p>
      </div>
      <form class="grid gap-5" @submit.prevent="submit">
        <label class="grid gap-2 text-sm font-semibold">
          Tên đăng nhập
          <input v-model="username" autocomplete="username" required class="h-11 rounded-lg border border-[#dfe5df] px-3 font-normal outline-none focus:border-[#66816d]" />
        </label>
        <label class="grid gap-2 text-sm font-semibold">
          Mật khẩu
          <input v-model="password" type="password" autocomplete="current-password" required class="h-11 rounded-lg border border-[#dfe5df] px-3 font-normal outline-none focus:border-[#66816d]" />
        </label>
        <p v-if="auth.error" role="alert" class="m-0 rounded-lg bg-[#fff1ee] p-3 text-sm text-[#a4493c]">{{ auth.error }}</p>
        <button type="submit" :disabled="!canSubmit" class="h-11 rounded-lg bg-[#315d46] font-bold text-white disabled:cursor-not-allowed disabled:opacity-60">
          {{ auth.pending ? 'Đang đăng nhập…' : auth.retrySeconds ? `Thử lại sau ${auth.retrySeconds} giây` : 'Đăng nhập' }}
        </button>
      </form>
    </section>
  </main>
</template>
