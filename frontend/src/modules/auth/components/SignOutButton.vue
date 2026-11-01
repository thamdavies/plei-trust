<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import AppIcon from '../../../shared/ui/AppIcon.vue'
import { useAuthStore } from '../stores/authStore'

const auth = useAuthStore()
const router = useRouter()
const root = ref(null)
const menuOpen = ref(false)
const displayName = computed(() => auth.user?.name || auth.user?.username || 'Tài khoản')
const initials = computed(() =>
  displayName.value
    .split(/\s+/)
    .slice(0, 2)
    .map((part) => part[0])
    .join('')
    .toUpperCase(),
)

function closeOnOutsideClick(event) {
  if (!root.value?.contains(event.target)) menuOpen.value = false
}

function closeOnEscape() {
  menuOpen.value = false
}

async function signOut() {
  if (await auth.submitSignOut()) {
    menuOpen.value = false
    await router.replace({ name: 'sign-in' })
  }
}

onMounted(() => document.addEventListener('pointerdown', closeOnOutsideClick))
onBeforeUnmount(() => document.removeEventListener('pointerdown', closeOnOutsideClick))
</script>

<template>
  <div ref="root" class="relative" @keydown.esc.stop.prevent="closeOnEscape">
    <button
      type="button"
      class="top-profile flex items-center gap-2 rounded-lg border-0 bg-transparent p-[0_0_0_5px] text-(--ink) hover:bg-black/5 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#66816d] max-[680px]:pl-1"
      aria-label="Thông tin tài khoản"
      aria-haspopup="menu"
      :aria-expanded="menuOpen"
      aria-controls="account-menu"
      @click="menuOpen = !menuOpen"
    >
      <span
        class="profile-avatar grid h-7.25 w-7.25 place-items-center rounded-full bg-[#c8916d] text-[13px] font-bold text-white max-[680px]:h-7 max-[680px]:w-7"
        >{{ initials }}</span
      >
      <span class="profile-name max-w-36 truncate text-[14px] font-semibold max-[680px]:hidden">{{ displayName }}</span>
      <AppIcon name="chevron" :size="13" />
    </button>

    <div
      v-if="menuOpen"
      id="account-menu"
      role="menu"
      aria-label="Menu tài khoản"
      class="absolute right-0 top-full z-30 mt-2 w-64 overflow-hidden rounded-xl border border-(--line) bg-(--surface) text-(--ink) shadow-[0_12px_32px_#14251b24]"
    >
      <div class="border-b border-(--line) px-4 py-3.5">
        <p class="m-0 truncate text-sm font-bold">{{ displayName }}</p>
        <p class="m-0 mt-1 truncate text-xs text-[#8a958c]">{{ auth.account?.name || 'Tài khoản Pawnify' }}</p>
      </div>
      <div class="p-2">
        <p v-if="auth.error" role="alert" class="m-0 px-2 py-2 text-xs text-[#a4493c]">{{ auth.error }}</p>
        <button
          type="button"
          role="menuitem"
          class="flex w-full items-center gap-2.5 rounded-lg px-2.5 py-2.5 text-left text-sm font-semibold text-[#a4493c] hover:bg-[#fff1ee] disabled:cursor-wait disabled:opacity-60"
          :disabled="auth.pending"
          @click="signOut"
        >
          <AppIcon name="log-out" :size="16" />
          {{ auth.pending ? 'Đang đăng xuất…' : 'Đăng xuất' }}
        </button>
      </div>
    </div>
  </div>
</template>
