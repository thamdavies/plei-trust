<script setup>
import { computed, ref, watch } from 'vue'
import { storeToRefs } from 'pinia'
import { useRoute, useRouter } from 'vue-router'
import AppIcon from '../AppIcon.vue'
import { useDashboardStore } from '../stores/dashboard'

const navOpen = ref(false)
const store = useDashboardStore()
const { activeMenu, darkMode, contracts } = storeToRefs(store)
const route = useRoute()
const router = useRouter()
watch(
  () => route.meta.label,
  (label) => {
    if (label) store.activeMenu = label
  },
  { immediate: true },
)
const search = ref('')
const showNotice = ref(true)
const toast = ref('')
const modalOpen = ref(false)
const newContract = ref({ customer: '', type: 'Cầm đồ', asset: '', amount: '' })
watch(darkMode, (value) => localStorage.setItem('pawnify-theme', value ? 'dark' : 'pawnify'))

const darkThemeClasses = [
  'is-dark',
  '[--canvas:#181f1a]',
  '[--surface:#202923]',
  '[--ink:#e6ece7]',
  '[--muted:#a2ada5]',
  '[--line:#354139]',
  '[--shadow:0_2px_8px_rgba(0,0,0,0.12)]',
  '[&_.topbar]:bg-[color:#202923]',
  '[&_.topbar]:border-[color:#354139]',
  '[&_.card]:bg-[color:#202923]',
  '[&_.card]:border-[color:#354139]',
  '[&_.metric-card]:bg-[color:#202923]',
  '[&_.metric-card]:border-[color:#354139]',
  '[&_.modal-box]:bg-[color:#202923]',
  '[&_.welcome-row_h1]:text-[color:#e6ece7]',
  '[&_.section-heading_h2]:text-[color:#e6ece7]',
  '[&_.metric-value_strong]:text-[color:#e6ece7]',
  '[&_.donut-chart_strong]:text-[color:#e6ece7]',
  '[&_.customer-cell_strong]:text-[color:#e6ece7]',
  '[&_.loan-amount]:text-[color:#e6ece7]',
  '[&_.chart-summary_strong]:text-[color:#e6ece7]',
  '[&_.top-profile]:text-[color:#e6ece7]',
  '[&_.search-control_kbd]:bg-[color:#2b362f]',
  '[&_.search-control_kbd]:border-[color:#3a463e]',
  '[&_.search-control_kbd]:text-[color:#c1cbc3]',
  '[&_.contracts-table_td]:border-[color:#354139]',
  '[&_.contracts-table_tbody_tr:last-child_td]:border-[color:#354139]',
  '[&_.contracts-table_th]:text-[color:#a2ada5]',
  '[&_.table-footer]:text-[color:#a2ada5]',
  '[&_.donut-chart::before]:bg-[color:#202923]',
  '[&_.compliance-alert]:bg-[color:#332f22]',
  '[&_.compliance-alert]:border-[color:#4b422a]',
  '[&_.alert-copy_strong]:text-[color:#e0d2a1]',
  '[&_.alert-copy_p]:text-[color:#c1b88f]',
  '[&_.alert-copy_a]:text-[color:#e0cc7a]',
  '[&_.metric-foot_b]:bg-[color:#29352d]',
  '[&_.metric-foot_b]:text-[color:#b3c6b8]',
  '[&_.metric-foot_b.gold]:bg-[color:#3a3524]',
  '[&_.metric-foot_b.gold]:text-[color:#d6bd70]',
  '[&_.metric-foot_b.rose]:bg-[color:#3b2b29]',
  '[&_.metric-foot_b.rose]:text-[color:#d99589]',
  '[&_.metric-icon.green]:bg-[color:#273a2e]',
  '[&_.metric-icon.green]:text-[color:#8cbb9a]',
  '[&_.metric-icon.blue]:bg-[color:#283440]',
  '[&_.metric-icon.blue]:text-[color:#9db5ce]',
  '[&_.metric-icon.gold]:bg-[color:#3a3524]',
  '[&_.metric-icon.gold]:text-[color:#d6bd70]',
  '[&_.metric-icon.rose]:bg-[color:#3b2b29]',
  '[&_.metric-icon.rose]:text-[color:#d99589]',
  '[&_.avatar-sage]:bg-[color:#2c3b31]',
  '[&_.avatar-sage]:text-[color:#b9d0bf]',
  '[&_.avatar-sky]:bg-[color:#2d3945]',
  '[&_.avatar-sky]:text-[color:#bbd0e3]',
  '[&_.avatar-rose]:bg-[color:#453235]',
  '[&_.avatar-rose]:text-[color:#e6bec4]',
  '[&_.avatar-gold]:bg-[color:#453e2c]',
  '[&_.avatar-gold]:text-[color:#e2d19d]',
  '[&_.contract-badge.badge-success]:bg-[color:#263d30]',
  '[&_.contract-badge.badge-success]:text-[color:#96c9a7]',
  '[&_.contract-badge.badge-warning]:bg-[color:#43381f]',
  '[&_.contract-badge.badge-warning]:text-[color:#e0c16f]',
  '[&_.chart-grid_i]:border-[color:#354139]',
  '[&_.metric-label]:text-[color:#a2ada5]',
  '[&_.section-heading_p]:text-[color:#a2ada5]',
  '[&_.welcome-subtitle]:text-[color:#a2ada5]',
  '[&_.chart-legend]:text-[color:#a2ada5]',
  '[&_.chart-caption]:text-[color:#a2ada5]',
  '[&_.page-footer]:text-[color:#a2ada5]',
  '[&_.date-button]:bg-[color:#26322b]',
  '[&_.date-button]:border-[color:#3a463e]',
  '[&_.date-button]:text-[color:#c1cbc3]',
  '[&_.period-button]:bg-[color:#26322b]',
  '[&_.period-button]:border-[color:#3a463e]',
  '[&_.period-button]:text-[color:#c1cbc3]',
  '[&_.portfolio-link]:bg-[color:#26322b]',
  '[&_.portfolio-link]:border-[color:#3a463e]',
  '[&_.portfolio-link]:text-[color:#c1cbc3]',
  '[&_.filter-button]:bg-[color:#26322b]',
  '[&_.filter-button]:border-[color:#3a463e]',
  '[&_.filter-button]:text-[color:#c1cbc3]',
].join(' ')

const menuGroups = [
  { label: 'TỔNG QUAN', items: [{ label: 'Tổng quan', icon: 'grid' }] },
  {
    label: 'NGHIỆP VỤ',
    items: [
      { label: 'Hợp đồng cầm đồ', icon: 'safe', count: '13' },
      { label: 'Hợp đồng tín chấp', icon: 'hand', count: '0' },
      { label: 'Hợp đồng trả góp', icon: 'calendar', count: '1' },
      { label: 'Khách hàng', icon: 'users' },
      { label: 'Cộng tác viên', icon: 'user-plus' },
    ],
  },
  {
    label: 'TÀI CHÍNH',
    items: [
      { label: 'Sổ quỹ', icon: 'wallet' },
      { label: 'Thu chi', icon: 'arrows' },
      { label: 'Báo cáo', icon: 'chart' },
    ],
  },
]

const metrics = [
  {
    label: 'Tổng quỹ tiền mặt',
    value: '84.500.000',
    unit: '₫',
    icon: 'wallet',
    color: 'green',
    hint: 'Có thể sử dụng ngay',
    trend: 'Tổng quỹ',
  },
  {
    label: 'Hợp đồng đang vay',
    value: '28',
    unit: '',
    icon: 'file',
    color: 'blue',
    hint: '23 cầm đồ · 5 trả góp',
    trend: '+4 tháng này',
  },
  {
    label: 'Tiền đang cho vay',
    value: '186.500.000',
    unit: '₫',
    icon: 'hand',
    color: 'gold',
    hint: 'Tổng dư nợ hiện tại',
    trend: '28 hợp đồng',
  },
  {
    label: 'Lãi đã thu tháng này',
    value: '12.450.000',
    unit: '₫',
    icon: 'coins',
    color: 'rose',
    hint: 'Tăng so với tháng trước',
    trend: '+8,4%',
  },
]

const filteredContracts = computed(() => {
  const term = search.value.trim().toLocaleLowerCase('vi')
  if (!term) return contracts.value
  return contracts.value.filter((row) =>
    `${row.code} ${row.customer} ${row.asset}`.toLocaleLowerCase('vi').includes(term),
  )
})

function notify(message) {
  toast.value = message
  window.clearTimeout(notify.timer)
  notify.timer = window.setTimeout(() => (toast.value = ''), 2800)
}

function selectMenu(label) {
  const paths = {
    'Tổng quan': '/',
    'Hợp đồng cầm đồ': '/contracts/pawn',
    'Hợp đồng tín chấp': '/contracts/credit',
    'Hợp đồng trả góp': '/contracts/installment',
    'Khách hàng': '/customers',
    'Cộng tác viên': '/collaborators',
    'Sổ quỹ': '/finance/fund',
    'Thu chi': '/finance/transactions',
    'Báo cáo': '/reports',
  }
  navOpen.value = false
  if (paths[label]) router.push(paths[label])
}

function createContract() {
  const customerName = newContract.value.customer.trim()
  const initials = customerName
    .split(/\s+/)
    .slice(-2)
    .map((part) => part[0])
    .join('')
    .toUpperCase()
  const loan = Number(newContract.value.amount)
  const code = `${newContract.value.type === 'Trả góp' ? 'TG' : 'PF'}-${String(Date.now()).slice(-4)}`
  store.addContract({
    code,
    customer: customerName,
    phone: '••• •• 0000',
    asset: newContract.value.asset.trim(),
    loan: new Intl.NumberFormat('vi-VN').format(loan),
    rate: newContract.value.type === 'Trả góp' ? 'Trả góp tháng' : 'Chờ thiết lập',
    due: 'Chưa thiết lập',
    status: 'Đang vay',
    initials,
    avatar: 'avatar-sage',
  })
  newContract.value = { customer: '', type: 'Cầm đồ', asset: '', amount: '' }
  modalOpen.value = false
  notify(`Đã thêm hợp đồng ${code} vào danh sách mẫu`)
}
</script>

<template>
  <div
    class="pawnify-app min-h-screen bg-(--canvas) text-(--ink) transition-[background_0.2s,color_0.2s]"
    :class="darkMode ? darkThemeClasses : ''"
    :data-theme="darkMode ? 'dark' : 'pawnify'"
  >
    <div
      v-if="navOpen"
      class="drawer-scrim hidden max-[680px]:block max-[680px]:fixed max-[680px]:inset-0 max-[680px]:bg-[#13221a8c] max-[680px]:z-18"
      @click="navOpen = false"
    ></div>
    <aside
      class="sidebar fixed z-20 inset-[0_auto_0_0] w-62.5 p-[24px_15px_13px] bg-[#21372e] text-[#eef3ee] flex flex-col shadow-[4px_0_25px_rgba(21,43,31,0.05)] max-[1160px]:w-55 max-[900px]:w-18 max-[900px]:p-[19px_9px_12px] max-[680px]:w-62.5 max-[680px]:transform-[translateX(-102%)] max-[680px]:transition-[transform_0.22s] max-[680px]:shadow-[8px_0_28px_#12271d30] max-[680px]:p-[21px_15px_13px] max-[680px]:[&.sidebar-open]:transform-[translateX(0)] max-[680px]:[&_.brand]:p-[0_9px] max-[680px]:[&_.brand-name]:[display:initial] max-[680px]:[&_.brand-tag]:[display:initial] max-[680px]:[&_.brand]:flex max-[680px]:[&_.store-copy]:flex max-[680px]:[&_.store-switch_>_svg]:block max-[680px]:[&_.nav-heading]:block max-[680px]:[&_.nav-item]:justify-start max-[680px]:[&_.nav-item]:p-[0_11px] max-[680px]:[&_.nav-item_>_span:not(.nav-count)]:inline max-[680px]:[&_.support-box]:block max-[680px]:[&_.profile-copy]:flex max-[680px]:[&_.profile-button_>_svg]:flex max-[680px]:[&_.nav-item.selected]:shadow-[inset_2px_0_#e1c571]"
      :class="{ 'sidebar-open': navOpen }"
    >
      <a
        href="#home"
        class="brand h-9.5 flex items-center gap-2.25 p-[0_9px] text-[#f9faf7] no-underline max-[900px]:p-[0_13px]"
        @click.prevent="selectMenu('Tổng quan')"
      >
        <span
          class="brand-mark w-6.75 h-6.75 rounded-[9px] bg-[#e3c978] grid place-items-center relative text-[#264836] [font:800_21px_Roboto] shadow-[0_2px_9px_#1112] [&_i]:absolute [&_i]:w-1 [&_i]:h-1 [&_i]:right-0.75 [&_i]:top-0.75 [&_i]:bg-[#f7f3e5] [&_i]:rounded-full"
          ><span>P</span><i></i
        ></span>
        <span class="brand-name [font:800_23px_Roboto] tracking-[-0.6px] max-[900px]:hidden"
          >pawnify</span
        >
        <span
          class="brand-tag text-[12px] tracking-[0.7px] text-[#e3c978] bg-[#ffffff11] [border:1px_solid_#ffffff20] rounded-sm p-[3px_5px] ml-px max-[900px]:hidden"
          >PRO</span
        >
      </a>
      <button
        class="store-switch m-[28px_0_25px] [border:1px_solid_#ffffff18] rounded-[10px] bg-[#ffffff0b] text-[#f2f5f0] flex items-center gap-2.5 p-2.5 w-full text-left [&_svg]:text-[#aab8ae] max-[900px]:justify-center max-[900px]:p-2 max-[900px]:m-[28px_0_24px] max-[900px]:[&_>_svg]:hidden"
        @click="notify('Bạn đang quản lý Pawnify Central')"
      >
        <span
          class="store-avatar w-8 h-8 rounded-lg bg-[#d9c171] text-[#273e32] grid place-items-center [font:700_15px_Roboto]"
          >D</span
        >
        <span
          class="store-copy flex flex-col gap-0.75 flex-1 [&_strong]:text-[15px] [&_strong]:font-bold [&_small]:text-[14px] [&_small]:text-[#aab9af] max-[900px]:hidden"
          ><strong>Pawnify Central</strong><small>Chi nhánh chính</small></span
        >
        <AppIcon name="chevrons" :size="16" />
      </button>
      <nav
        class="main-nav flex flex-col gap-5.75 max-[900px]:gap-5"
        aria-label="Điều hướng chính"
      >
        <div
          v-for="group in menuGroups"
          :key="group.label"
          class="nav-group flex flex-col gap-0.75"
        >
          <p
            class="nav-heading m-[0_0_8px_10px] text-[#819589] text-[12px] font-bold tracking-[1.25px] max-[900px]:hidden"
          >
            {{ group.label }}
          </p>
          <button
            v-for="item in group.items"
            :key="item.label"
            class="nav-item h-9.75 [border:0] bg-transparent text-[#becbc2] flex items-center text-left gap-2.75 rounded-[7px] p-[0_11px] text-[15px] font-medium transition-[0.16s] [&:hover]:bg-[#ffffff0b] [&:hover]:text-white [&.selected]:bg-[#ffffff15] [&.selected]:text-[#f9f9f1] [&.selected]:font-bold [&.selected]:shadow-[inset_2px_0_#e1c571] [&.selected_svg]:text-[#e4c978] [&_svg]:text-[#9caf9f] [&_svg]:flex-none max-[900px]:[&_>_span:not(.nav-count)]:hidden max-[900px]:justify-center max-[900px]:p-0 max-[900px]:[&.selected]:shadow-[inset_0_-2px_#e1c571]"
            :class="{ selected: activeMenu === item.label }"
            @click="selectMenu(item.label)"
          >
            <AppIcon :name="item.icon" :size="17" />
            <span>{{ item.label }}</span>
            <span
              v-if="item.count"
              class="nav-count ml-auto rounded-[5px] bg-[#ffffff14] text-[#d7e0d8] p-[3px_6px] text-[14px] max-[900px]:hidden"
              >{{ item.count }}</span
            >
          </button>
        </div>
      </nav>
      <div
        class="sidebar-bottom mt-auto max-[900px]:hidden max-[680px]:[display:initial]"
      >
        <div
          class="support-box [border:1px_solid_#ffffff15] bg-[#ffffff08] rounded-[10px] p-[12px_12px_11px] mb-3.25 [&_strong]:text-[14px] [&_p]:text-[14px] [&_p]:leading-normal [&_p]:text-[#a9b8ad] [&_p]:m-[5px_0_10px] [&_>_button]:inline-flex [&_>_button]:items-center [&_>_button]:gap-1 [&_>_button]:[border:0] [&_>_button]:p-0 [&_>_button]:bg-transparent [&_>_button]:text-[#e4cb7a] [&_>_button]:text-[14px] [&_>_button]:font-bold"
        >
          <div
            class="support-art w-6.75 h-6.75 rounded-lg grid place-items-center bg-[#ffffff12] text-[#e0c775] mb-2.25"
          >
            <AppIcon name="shield" :size="19" />
          </div>
          <strong>Pawnify đồng hành cùng bạn</strong>
          <p>Hỗ trợ vận hành cửa hàng mỗi ngày.</p>
          <button @click="notify('Đội ngũ Pawnify sẽ sớm hỗ trợ bạn')">
            Liên hệ hỗ trợ <AppIcon name="arrow-up" :size="12" />
          </button>
        </div>
        <button
          class="profile-button flex items-center gap-2.25 w-full text-left text-[#f5f6f3] bg-transparent [border:0] [border-top:1px_solid_#ffffff19] p-[13px_4px_1px] [&_>_svg]:text-[#a8b6ac] max-[900px]:justify-center"
          @click="notify('Tài khoản quản trị viên')"
        >
          <span
            class="profile-avatar w-7.75 h-7.75 grid place-items-center rounded-full bg-[#c8916d] text-white text-[14px] font-bold"
            >PF</span
          >
          <span
            class="profile-copy flex flex-col gap-0.75 flex-1 [&_strong]:text-[15px] [&_strong]:font-bold [&_small]:text-[14px] [&_small]:text-[#aab9af]"
            ><strong>Admin Pawnify</strong><small>Quản trị viên</small></span
          >
          <AppIcon name="more" :size="18" />
        </button>
      </div>
    </aside>

    <main
      class="main-area min-h-screen ml-62.5 max-[1160px]:ml-55 max-[900px]:ml-18 max-[680px]:ml-0"
    >
      <header
        class="topbar h-15.75 bg-(--surface) [border-bottom:1px_solid_var(--line)] flex items-center justify-between p-[0_34px] sticky top-0 z-12 [&_.btn-ghost]:text-[#738078] [&_.btn-square]:w-8 [&_.btn-square]:h-8 [&_.btn-square]:min-h-8 max-[1160px]:p-[0_22px] max-[680px]:h-14 max-[680px]:p-[0_12px] max-[680px]:gap-1"
      >
        <button
          class="btn btn-ghost btn-square menu-toggle hidden max-[680px]:inline-flex max-[680px]:flex-none"
          aria-label="Mở menu"
          @click="navOpen = !navOpen"
        >
          <AppIcon name="menu" :size="20" />
        </button>
        <div
          class="breadcrumbs flex items-center gap-2.25 text-[14px] text-[#9aa49c] [&_svg]:text-[#c2cac3] [&_strong]:font-bold [&_strong]:text-[#46534b] max-[680px]:hidden"
        >
          <strong>{{ activeMenu }}</strong>
        </div>
        <div class="topbar-actions flex items-center gap-2.5 max-[680px]:gap-0.5">
          <label
            class="search-control w-61.25 h-8.25 flex items-center gap-1.75 [border:1px_solid_var(--line)] rounded-[7px] p-[0_9px] text-[#9aa49d] [&_.input]:[border:0] [&_.input]:bg-transparent [&_.input]:[outline:0] [&_.input]:shadow-[none] [&_.input]:min-w-0 [&_.input]:h-7.5 [&_.input]:flex-1 [&_.input]:p-0 [&_.input]:text-[14px] [&_.input]:text-(--ink) [&_kbd]:[font:14px_Roboto] [&_kbd]:p-[3px_5px] [&_kbd]:bg-[#f6f8f6] [&_kbd]:[border:1px_solid_#edf0ed] [&_kbd]:rounded-sm [&_kbd]:whitespace-nowrap [&_kbd]:text-[#929c94] max-[680px]:w-[min(44vw,225px)] max-[680px]:h-7.75 max-[680px]:p-[0_7px] max-[680px]:gap-1.25 max-[680px]:[&_.input]:text-[14px] max-[680px]:[&_.input::placeholder]:text-[#a6aea7] max-[680px]:[&_kbd]:hidden"
            ><AppIcon name="search" :size="17" /><input
              v-model="search"
              class="input input-ghost"
              placeholder="Tìm hợp đồng, khách hàng..."
              aria-label="Tìm kiếm"
            /><kbd>⌘ K</kbd></label
          >
          <button
            class="btn btn-ghost btn-square theme-toggle"
            aria-label="Đổi giao diện"
            @click="darkMode = !darkMode"
          >
            <AppIcon :name="darkMode ? 'sun' : 'moon'" :size="18" />
          </button>
          <button
            class="btn btn-ghost btn-square notification-button relative"
            aria-label="Thông báo"
            @click="notify('Bạn không có thông báo mới')"
          >
            <AppIcon name="bell" :size="19" /><span
              class="notification-dot absolute w-1.5 h-1.5 right-1.5 top-1.25 bg-[#d67663] [border:1px_solid_var(--surface)] rounded-full"
            ></span>
          </button>
          <button
            class="top-profile flex items-center gap-2 [border:0] bg-transparent text-(--ink) p-[0_0_0_5px] [&_.profile-avatar]:w-7.25 [&_.profile-avatar]:h-7.25 [&_svg]:text-[#929d94] max-[680px]:[&_>_svg]:hidden max-[680px]:pl-1 max-[680px]:[&_.profile-avatar]:w-7 max-[680px]:[&_.profile-avatar]:h-7"
            @click="notify('Tài khoản quản trị viên')"
          >
            <span
              class="profile-avatar w-7.75 h-7.75 grid place-items-center rounded-full bg-[#c8916d] text-white text-[14px] font-bold"
              >PF</span
            ><span class="profile-name text-[14px] font-semibold max-[680px]:hidden"
              >Admin Pawnify</span
            ><AppIcon name="chevron" :size="13" />
          </button>
        </div>
      </header>

      <div
        class="page-content w-[min(1520px,100%)] m-[0_auto] p-[28px_34px_16px] min-[1500px]:pt-9 max-[1160px]:p-[25px_22px_15px] max-[680px]:p-[21px_13px_14px]"
      >
        <section
          class="welcome-row flex justify-between items-end mb-4.75 [&_h1]:[font:700_24px_Roboto,sans-serif] [&_h1]:tracking-[-0.55px] [&_h1]:m-0 [&_h1]:text-[#27372d] max-[680px]:items-start max-[680px]:gap-1.75 max-[680px]:mb-3.75 max-[680px]:[&_h1]:text-[22px] max-[680px]:[&_h1]:leading-[1.35] max-[390px]:[&_h1]:text-[20px]"
        >
          <div>
            <div
              class="eyebrow flex items-center gap-1.75 mb-2 text-[#96a197] text-[12px] tracking-[1.05px] font-bold max-[680px]:text-[11px] max-[680px]:mb-1.75"
            >
              <span
                class="live-dot w-1.5 h-1.5 rounded-full bg-[#58aa7d] shadow-[0_0_0_3px_#58aa7d1c]"
              ></span>
              CHỦ NHẬT, 01 THÁNG 11, 2026
              <span class="sample-tag">DỮ LIỆU MẪU</span>
            </div>
            <h1>
              Chào buổi sáng, quản trị viên
              <span class="wave [font:600_18px_sans-serif] text-[#d6b95f]">✦</span>
            </h1>
            <p
              class="welcome-subtitle text-[14px] text-[#89948c] m-[6px_0_0] max-[680px]:text-[14px] max-[680px]:leading-[1.45] max-[680px]:max-w-61.25"
            >
              Tổng quan hoạt động cửa hàng của bạn hôm nay.
            </p>
          </div>
          <button
            class="btn date-button h-8.5 min-h-8.5 bg-(--surface) [border:1px_solid_var(--line)] text-[#66736a] rounded-[7px] text-[14px] font-semibold gap-2 p-[0_10px] [&_svg:first-child]:text-[#859389] [&_svg:last-child]:text-[#9aa49d] [&_svg:last-child]:ml-1.5 max-[680px]:h-7.5 max-[680px]:min-h-7.5 max-[680px]:whitespace-nowrap max-[680px]:p-[0_7px] max-[680px]:text-[12px] max-[680px]:gap-1.25 max-[680px]:[&_svg:first-child]:hidden max-[390px]:text-[11px]"
            @click="notify('Đang hiển thị dữ liệu hôm nay')"
          >
            <AppIcon name="calendar" :size="15" /> Hôm nay <AppIcon name="chevron" :size="14" />
          </button>
        </section>

        <section
          v-if="showNotice"
          class="alert compliance-alert relative flex items-start gap-2.75 bg-[#fcf8eb] [border:1px_solid_#f0e8ca] rounded-[9px] p-[12px_42px_12px_13px] mb-3.75 text-[#4c4e41] shadow-[none] max-[680px]:p-[10px_33px_10px_10px] max-[680px]:gap-2 max-[680px]:mb-2.75"
        >
          <span
            class="alert-mark w-7 h-7 grid place-items-center rounded-lg bg-[#f6edcf] text-[#947a31] flex-none max-[680px]:w-6.25 max-[680px]:h-6.25"
            ><AppIcon name="shield" :size="18"
          /></span>
          <div
            class="alert-copy [&_strong]:text-[14px] [&_strong]:font-bold [&_strong]:text-[#695b30] [&_p]:text-[14px] [&_p]:text-[#817958] [&_p]:m-[4px_0_6px] [&_p]:leading-normal [&_a]:inline-flex [&_a]:items-center [&_a]:gap-0.75 [&_a]:text-[14px] [&_a]:font-bold [&_a]:text-[#7a682e] [&_a]:no-underline max-[680px]:[&_strong]:text-[14px] max-[680px]:[&_p]:text-[12px] max-[680px]:[&_p]:leading-[1.45] max-[680px]:[&_a]:text-[12px]"
          >
            <strong>Vận hành minh bạch, tuân thủ đúng quy định</strong>
            <p>
              Hãy đảm bảo lãi suất và các khoản phí được thông báo rõ ràng trong hợp đồng, phù hợp
              với quy định pháp luật hiện hành.
            </p>
            <a
              href="#compliance"
              @click.prevent="notify('Mục hướng dẫn tuân thủ đang được cập nhật')"
              >Xem hướng dẫn tuân thủ <AppIcon name="arrow-up" :size="12"
            /></a>
          </div>
          <button
            class="btn btn-ghost btn-square close-alert absolute right-1.25 top-1.25 text-[#a99b68]"
            aria-label="Đóng thông báo"
            @click="showNotice = false"
          >
            <AppIcon name="close" :size="16" />
          </button>
        </section>

        <section
          class="stats stats-horizontal metric-grid grid grid-flow-row grid-cols-4 gap-3.25 mb-3.5 rounded-none bg-transparent p-0 shadow-none max-[680px]:grid-cols-2 max-[680px]:gap-2.25 max-[680px]:mb-2.75"
          aria-label="Chỉ số cửa hàng"
        >
          <article
            v-for="metric in metrics"
            :key="metric.label"
            class="card stat metric-card block rounded-[9px] bg-(--surface) [border:1px_solid_var(--line)] shadow-(--shadow) p-[14px_15px_12px] min-h-31.75 min-[1500px]:min-h-34.25 max-[1160px]:p-3 max-[680px]:min-h-29 max-[680px]:p-2.5"
          >
            <div class="metric-head flex items-center justify-between">
              <span
                class="metric-icon grid place-items-center w-7.75 h-7.75 rounded-lg [&.green]:bg-[#edf5ef] [&.green]:text-[#3c7759] [&.blue]:bg-[#edf2f8] [&.blue]:text-[#547491] [&.gold]:bg-[#faf3df] [&.gold]:text-[#ae8c35] [&.rose]:bg-[#faeeee] [&.rose]:text-[#ba6d64] max-[680px]:w-7 max-[680px]:h-7"
                :class="metric.color"
                ><AppIcon :name="metric.icon" :size="18" /></span
              ><button
                class="metric-more grid place-items-center [border:0] bg-transparent text-[#a6afa7] w-6.25 h-6.25 rounded-[5px] [&:hover]:bg-[#f4f6f3]"
                :aria-label="`Thao tác ${metric.label}`"
                @click="notify(metric.label)"
              >
                <AppIcon name="more" :size="17" />
              </button>
            </div>
            <p
              class="stat-title metric-label text-[14px] text-[#8d988f] m-[11px_0_4px] max-[680px]:text-[12px] max-[680px]:m-[10px_0_4px]"
            >
              {{ metric.label }}
            </p>
            <div
              class="stat-value metric-value flex items-baseline gap-1 [&_strong]:[font:700_22px_Roboto,sans-serif] [&_strong]:tracking-[-0.55px] [&_strong]:text-[#303d34] [&_span]:[font:600_15px_Roboto] [&_span]:text-[#65726a] max-[1160px]:[&_strong]:text-[22px] max-[680px]:[&_strong]:text-[20px] max-[680px]:[&_span]:text-[14px] max-[390px]:[&_strong]:text-[18px]"
            >
              <strong>{{ metric.value }}</strong
              ><span>{{ metric.unit }}</span>
            </div>
            <div
              class="stat-desc metric-foot flex justify-between gap-1.25 items-center mt-1.25 text-[12px] text-[#a0a9a1] [&_b]:text-[12px] [&_b]:text-[#438261] [&_b]:bg-[#eef6f0] [&_b]:rounded-sm [&_b]:p-[3px_5px] [&_b.blue]:text-[#57738e] [&_b.blue]:bg-[#eff3f7] [&_b.gold]:text-[#a0802c] [&_b.gold]:bg-[#faf5e6] [&_b.rose]:text-[#ac6b62] [&_b.rose]:bg-[#fbf0ee] max-[900px]:flex-wrap max-[900px]:[&_>_span]:hidden max-[680px]:mt-1 max-[680px]:text-[11px] max-[680px]:[&_>_span]:block max-[680px]:[&_b]:text-[11px]"
            >
              <span>{{ metric.hint }}</span
              ><b :class="metric.color">{{ metric.trend }}</b>
            </div>
          </article>
        </section>

        <section
          class="dashboard-grid grid grid-cols-[minmax(0,1.75fr)_minmax(265px,0.8fr)] gap-3.5 mb-3.5 max-[1160px]:grid-cols-[minmax(0,1.5fr)_minmax(245px,0.8fr)] max-[900px]:grid-cols-[minmax(0,1.35fr)_minmax(220px,0.85fr)] max-[680px]:grid-cols-[1fr] max-[680px]:gap-2.5 max-[680px]:mb-2.75"
        >
          <article
            class="card chart-card rounded-[9px] bg-(--surface) [border:1px_solid_var(--line)] shadow-(--shadow) p-4 max-[680px]:p-3.25"
          >
            <div
              class="section-heading flex items-start justify-between [&_h2]:[font:700_14px_Roboto,sans-serif] [&_h2]:tracking-[-0.1px] [&_h2]:m-0 [&_h2]:text-[#354239] [&_p]:text-[14px] [&_p]:text-[#99a39b] [&_p]:m-[4px_0_0] max-[680px]:[&_h2]:text-[15px] max-[680px]:[&_p]:text-[12px]"
            >
              <div>
                <h2>Dòng tiền cửa hàng</h2>
                <p>Thu chi trong 7 ngày gần nhất</p>
              </div>
              <button
                class="btn period-button h-7 min-h-7 [border:1px_solid_var(--line)] bg-(--surface) text-[#758078] text-[14px] font-semibold rounded-md gap-2.25 p-[0_8px] [&_svg]:text-[#9ca69f]"
                @click="notify('Biểu đồ đang hiển thị 7 ngày gần nhất')"
              >
                7 ngày <AppIcon name="chevron" :size="13" />
              </button>
            </div>
            <div
              class="chart-legend flex items-center gap-4 m-[17px_0_5px] text-[12px] text-[#879289] [&_>_span]:flex [&_>_span]:items-center [&_>_span]:gap-1.5 max-[680px]:m-[14px_0_3px] max-[680px]:gap-2.75 max-[680px]:text-[11px]"
            >
              <span
                ><i class="legend-income w-1.75 h-1.75 rounded-full bg-[#468466]"></i> Tiền
                thu</span
              ><span
                ><i
                  class="legend-outcome w-1.75 h-1.75 rounded-full bg-[#c4af6e]"
                ></i>
                Tiền chi</span
              >
              <div
                class="chart-summary ml-auto flex flex-col items-end gap-0.5 [&_small]:text-[11px] [&_small]:text-[#a2aaa3] [&_small]:tracking-[0.7px] [&_strong]:[font:700_14px_Roboto] [&_strong]:text-[#34463a] [&_i]:not-italic [&_i]:text-[14px] max-[680px]:[&_strong]:text-[14px]"
              >
                <small>THU RÒNG</small><strong>+ 12.450.000 <i>₫</i></strong>
              </div>
            </div>
            <div
              class="chart-container h-46 flex gap-2.25 pt-2 min-[1500px]:h-52.5 max-[680px]:h-41.25 max-[680px]:gap-1.25"
            >
              <div
                class="y-labels w-6.75 flex flex-col justify-between p-[0_0_19px] text-[#a4aca5] text-[12px] max-[680px]:text-[11px] max-[680px]:w-5.75"
              >
                <span>20tr</span><span>15tr</span><span>10tr</span><span>5tr</span><span>0</span>
              </div>
              <div
                class="chart-plot flex-1 relative min-w-0 [&_svg]:absolute [&_svg]:w-full [&_svg]:h-[calc(100%-19px)] [&_svg]:overflow-visible"
              >
                <div
                  class="chart-grid absolute inset-[0_0_19px] flex flex-col justify-between [&_i]:[border-top:1px_dashed_#edf0ec]"
                >
                  <i></i><i></i><i></i><i></i><i></i>
                </div>
                <svg
                  viewBox="0 0 760 230"
                  preserveAspectRatio="none"
                  role="img"
                  aria-label="Biểu đồ thu chi bảy ngày"
                >
                  <defs>
                    <linearGradient id="incomeFill" x1="0" x2="0" y1="0" y2="1">
                      <stop offset="0" stop-color="#43866c" stop-opacity=".2" />
                      <stop offset="1" stop-color="#43866c" stop-opacity="0" />
                    </linearGradient>
                  </defs>
                  <path
                    class="area-income fill-[url(#incomeFill)]"
                    d="M0 174 C32 162 47 169 72 149 S116 155 141 133 180 142 207 118 248 128 277 104 317 122 347 95 384 110 414 82 454 100 484 69 522 80 554 54 593 68 622 38 662 50 694 29 727 38 760 18 L760 230 L0 230Z"
                  />
                  <path
                    class="line-income fill-none stroke-[#4b8969] stroke-[2.4] [vector-effect:non-scaling-stroke]"
                    d="M0 174 C32 162 47 169 72 149 S116 155 141 133 180 142 207 118 248 128 277 104 317 122 347 95 384 110 414 82 454 100 484 69 522 80 554 54 593 68 622 38 662 50 694 29 727 38 760 18"
                  />
                  <path
                    class="line-outcome fill-none stroke-[#c4af6e] stroke-[1.7] [vector-effect:non-scaling-stroke] [stroke-dasharray:4_4]"
                    d="M0 208 C34 199 50 203 72 190 S115 192 141 178 181 187 207 168 248 177 277 158 316 168 347 149 384 161 414 136 452 151 484 128 522 140 554 115 593 129 622 100 660 112 694 87 727 96 760 73"
                  />
                  <circle
                    class="chart-highlight fill-white stroke-[#4b8969] stroke-3 [vector-effect:non-scaling-stroke]"
                    cx="554"
                    cy="54"
                    r="5"
                  />
                </svg>
                <div
                  class="x-labels absolute left-0 right-0 bottom-0 flex justify-between text-[#9ca69e] text-[12px] max-[680px]:text-[11px]"
                >
                  <span>26/10</span><span>27/10</span><span>28/10</span><span>29/10</span
                  ><span>30/10</span><span>31/10</span><span>01/11</span>
                </div>
              </div>
            </div>
            <div
              class="chart-caption flex justify-between m-[7px_1px_0_36px] text-[#a3aca5] text-[12px] [&_span:first-child]:flex [&_span:first-child]:items-center [&_span:first-child]:gap-1.25 [&_i]:w-1.5 [&_i]:h-1.5 [&_i]:bg-[#62a17e] [&_i]:rounded-full max-[680px]:ml-7 max-[680px]:text-[11px]"
            >
              <span><i></i> Cập nhật theo giao dịch của cửa hàng</span><span>Đơn vị: VNĐ</span>
            </div>
          </article>

          <article
            class="card portfolio-card rounded-[9px] bg-(--surface) [border:1px_solid_var(--line)] shadow-(--shadow) p-4 flex flex-col max-[680px]:p-3.25 max-[680px]:min-h-0"
          >
            <div
              class="section-heading flex items-start justify-between [&_h2]:[font:700_14px_Roboto,sans-serif] [&_h2]:tracking-[-0.1px] [&_h2]:m-0 [&_h2]:text-[#354239] [&_p]:text-[14px] [&_p]:text-[#99a39b] [&_p]:m-[4px_0_0] max-[680px]:[&_h2]:text-[15px] max-[680px]:[&_p]:text-[12px]"
            >
              <div>
                <h2>Cơ cấu hợp đồng</h2>
                <p>28 hợp đồng đang hoạt động</p>
              </div>
              <button
                class="btn btn-ghost btn-square tiny-more min-h-6.25 w-6.25 h-6.25 text-[#9ba49d]"
                aria-label="Tùy chọn"
                @click="notify('Cơ cấu hợp đồng')"
              >
                <AppIcon name="more" :size="17" />
              </button>
            </div>
            <div
              class="donut-wrap h-38.5 grid place-items-center relative min-[1500px]:h-43.75 max-[680px]:h-36"
            >
              <div
                class="donut-chart w-32.5 h-32.5 rounded-full bg-[conic-gradient(#3f7658_0_75%,#d6bd78_75%_90%,#e8eee8_90%_100%)] grid place-items-center relative transform-[rotate(-45deg)] [&::before]:[content:''] [&::before]:absolute [&::before]:inset-3.25 [&::before]:rounded-full [&::before]:bg-(--surface) [&_>_div]:relative [&_>_div]:z-1 [&_>_div]:flex [&_>_div]:flex-col [&_>_div]:items-center [&_>_div]:transform-[rotate(45deg)] [&_strong]:[font:800_27px_Roboto] [&_strong]:tracking-[-0.6px] [&_strong]:text-[#35443a] [&_span]:text-[12px] [&_span]:text-[#9aa49c] max-[680px]:w-29.5 max-[680px]:h-29.5"
              >
                <div><strong>14</strong><span>Hợp đồng</span></div>
              </div>
              <div class="donut-center-label"></div>
            </div>
            <div
              class="portfolio-legend grid gap-2.75 mt-0 [&_>_div]:flex [&_>_div]:items-center [&_>_div]:gap-2 [&_>_div]:text-[14px] [&_strong]:text-[14px] [&_strong]:text-[#536158] [&_strong_small]:font-normal [&_strong_small]:text-[#a0a9a1] [&_strong_small]:text-[12px] [&_b]:text-[12px] [&_b]:text-[#839087] [&_b]:min-w-8.5 [&_b]:text-right max-[680px]:gap-2.25"
            >
              <div>
                <span
                  class="portfolio-type flex items-center gap-1.5 flex-1 text-[#778279] [&_i]:w-1.75 [&_i]:h-1.75 [&_i]:rounded-full [&_i]:bg-[#3f7658] [&_.installment-dot]:bg-[#d6bd78]"
                  ><i class="pawn-dot"></i>Cầm đồ</span
                ><strong>23 <small>hợp đồng</small></strong
                ><b>82,1%</b>
              </div>
              <div>
                <span
                  class="portfolio-type flex items-center gap-1.5 flex-1 text-[#778279] [&_i]:w-1.75 [&_i]:h-1.75 [&_i]:rounded-full [&_i]:bg-[#3f7658] [&_.installment-dot]:bg-[#d6bd78]"
                  ><i class="installment-dot"></i>Trả góp</span
                ><strong>5 <small>hợp đồng</small></strong
                ><b>17,9%</b>
              </div>
            </div>
            <button
              class="btn btn-outline portfolio-link w-full h-7.5 min-h-7.5 mt-auto p-[0_9px] justify-between [border:1px_solid_var(--line)] bg-transparent text-[#55675b] text-[14px] max-[680px]:mt-3.25"
              @click="selectMenu('Hợp đồng cầm đồ')"
            >
              Quản lý hợp đồng <AppIcon name="arrow-right" :size="15" />
            </button>
          </article>
        </section>

        <section
          class="card contracts-card rounded-[9px] bg-(--surface) [border:1px_solid_var(--line)] shadow-(--shadow) p-4 pb-2 max-[680px]:p-3.25"
        >
          <div
            class="section-heading contracts-heading flex items-start justify-between [&_h2]:[font:700_14px_Roboto,sans-serif] [&_h2]:tracking-[-0.1px] [&_h2]:m-0 [&_h2]:text-[#354239] [&_p]:text-[14px] [&_p]:text-[#99a39b] [&_p]:m-[4px_0_0] max-[680px]:[&_h2]:text-[15px] max-[680px]:[&_p]:text-[12px] max-[680px]:items-start max-[680px]:gap-2 max-[680px]:[&_.section-heading]:gap-2"
          >
            <div>
              <h2>Hợp đồng gần đây</h2>
              <p>Theo dõi các khoản vay và ngày thanh toán</p>
            </div>
            <div
              class="contract-actions flex items-center gap-1.75 max-[680px]:gap-1.25 max-[390px]:gap-0.75"
            >
              <button
                class="btn btn-outline filter-button h-7.5 min-h-7.5 rounded-md text-[14px] p-[0_9px] gap-1.25 bg-transparent [border:1px_solid_var(--line)] text-[#768179] max-[680px]:hidden"
                @click="notify('Bộ lọc hợp đồng')"
              >
                <AppIcon name="filter" :size="14" /> Lọc</button
              ><button
                class="btn btn-primary add-button h-7.5 min-h-7.5 rounded-md text-[14px] p-[0_9px] gap-1.25 bg-[#315d46] border-[#315d46] text-white [&:hover]:bg-[#254c3b] [&:hover]:border-[#254c3b] max-[680px]:p-[0_7px] max-[680px]:text-[12px] max-[390px]:text-[11px]"
                @click="modalOpen = true"
              >
                <AppIcon name="plus" :size="15" /> Tạo hợp đồng</button
              ><a
                href="#contracts"
                class="see-all flex items-center gap-1 ml-1.75 text-[#53745f] font-bold text-[14px] no-underline max-[680px]:ml-0.5 max-[680px]:text-[12px] max-[680px]:gap-0.5 max-[680px]:whitespace-nowrap max-[390px]:text-[11px]"
                @click.prevent="selectMenu('Hợp đồng cầm đồ')"
                >Xem tất cả <AppIcon name="arrow-right" :size="14"
              /></a>
            </div>
          </div>
          <div class="table-wrap overflow-auto m-[16px_-2px_0] max-[680px]:mt-3.5">
            <table
              class="table contracts-table w-full min-w-187.5 border-collapse [&_th]:p-[0_9px_9px] [&_th]:[border-bottom:1px_solid_var(--line)] [&_th]:text-[#9aa49c] [&_th]:text-[11px] [&_th]:tracking-[0.65px] [&_th]:font-bold [&_th]:text-left [&_th]:whitespace-nowrap [&_td]:h-13.25 [&_td]:p-[5px_9px] [&_td]:[border-bottom:1px_solid_#f0f2ef] [&_td]:text-[#657168] [&_td]:text-[14px] [&_td]:whitespace-nowrap [&_tbody_tr:last-child_td]:[border-bottom:0] max-[1160px]:[&_td]:pl-1.75 max-[1160px]:[&_td]:pr-1.75 max-[680px]:min-w-181.25 max-[680px]:[&_th]:text-[11px] max-[680px]:[&_td]:h-12.25"
            >
              <thead>
                <tr>
                  <th>MÃ HỢP ĐỒNG</th>
                  <th>KHÁCH HÀNG</th>
                  <th>TÀI SẢN</th>
                  <th>TIỀN CẦM</th>
                  <th>NGÀY ĐẾN HẠN</th>
                  <th>TÌNH TRẠNG</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in filteredContracts" :key="row.code">
                  <td>
                    <button
                      class="contract-code p-0 [border:0] bg-transparent text-[#477454] text-[14px] font-bold"
                      @click="notify(`Hợp đồng ${row.code}`)"
                    >
                      {{ row.code }}
                    </button>
                  </td>
                  <td>
                    <div
                      class="customer-cell flex items-center gap-1.75 [&_>_span:last-child]:flex [&_>_span:last-child]:flex-col [&_>_span:last-child]:gap-0.75 [&_strong]:text-[14px] [&_strong]:text-[#3e4c42] [&_small]:text-[12px] [&_small]:text-[#a1aaa2]"
                    >
                      <span
                        class="avatar customer-avatar w-6.5 h-6.5 min-w-6.5 rounded-lg text-[12px] font-bold [&.avatar-sage]:bg-[#edf3e8] [&.avatar-sage]:text-[#688254] [&.avatar-sky]:bg-[#e9f0f6] [&.avatar-sky]:text-[#537994] [&.avatar-rose]:bg-[#f7eceb] [&.avatar-rose]:text-[#a96e68] [&.avatar-gold]:bg-[#f8f1dd] [&.avatar-gold]:text-[#9c823f]"
                        :class="row.avatar"
                        >{{ row.initials }}</span
                      ><span
                        ><strong>{{ row.customer }}</strong
                        ><small>{{ row.phone }}</small></span
                      >
                    </div>
                  </td>
                  <td>
                    <span class="asset-name block text-[#56635a] text-[14px]">{{
                      row.asset
                    }}</span
                    ><small
                      class="asset-type text-[12px] text-[#a1aaa2] block mt-0.75"
                      >Tài sản cầm cố</small
                    >
                  </td>
                  <td>
                    <strong class="loan-amount block text-[#4b594f] text-[14px]"
                      >{{ row.loan }} ₫</strong
                    ><small
                      class="loan-rate text-[12px] block text-[#a17e39] mt-0.75"
                      >{{ row.rate }}</small
                    >
                  </td>
                  <td>{{ row.due }}</td>
                  <td>
                    <span
                      class="badge contract-badge h-auto min-h-0 [border:0] rounded-[5px] p-[4px_6px] text-[11px] font-bold whitespace-nowrap [&.badge-success]:bg-[#eef6ef] [&.badge-success]:text-[#4b8760] [&.badge-warning]:bg-[#fbf4e3] [&.badge-warning]:text-[#a38031]"
                      :class="row.status === 'Sắp đến hạn' ? 'badge-warning' : 'badge-success'"
                      >{{ row.status }}</span
                    >
                  </td>
                  <td>
                    <button
                      class="btn btn-ghost btn-square row-action h-6.5 min-h-6.5 w-6.5 text-[#8f9a91]"
                      :aria-label="`Tùy chọn ${row.code}`"
                      @click="notify(`Thao tác hợp đồng ${row.code}`)"
                    >
                      <AppIcon name="more" :size="17" />
                    </button>
                  </td>
                </tr>
                <tr v-if="!filteredContracts.length">
                  <td colspan="7" class="empty-state text-center text-[#99a39b] p-5.5!">
                    Không tìm thấy hợp đồng phù hợp.
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div
            class="table-footer flex items-center justify-between p-[10px_8px_2px] [border-top:1px_solid_#f0f2ef] text-[#9ba49d] text-[12px] [&_strong]:text-[#66746a] [&_button]:flex [&_button]:items-center [&_button]:gap-1.5 [&_button]:[border:0] [&_button]:bg-transparent [&_button]:text-[#7b887e] [&_button]:text-[12px] max-[680px]:text-[11px]"
          >
            <span
              >Hiển thị <strong>{{ filteredContracts.length }}</strong> trên
              {{ contracts.length }} hợp đồng</span
            ><button @click="notify('Đang hiển thị 10 hợp đồng mỗi trang')">
              10 mỗi trang <AppIcon name="chevron" :size="12" />
            </button>
          </div>
        </section>
        <footer
          class="page-footer flex justify-between p-[16px_2px_2px] text-[#a0a9a1] text-[12px] [&_i]:not-italic [&_i]:text-[#c9856a] max-[680px]:text-[11px]"
        >
          <span>© 2026 Pawnify</span><span>Quản lý sáng suốt, kinh doanh an tâm <i>♥</i></span>
        </footer>
      </div>
    </main>

    <div
      v-if="modalOpen"
      class="modal modal-open fixed inset-0 z-35 h-screen w-screen max-h-none max-w-none border-0 rounded-none bg-[#14251bc7] p-4 flex items-center justify-center"
      @click.self="modalOpen = false"
    >
      <div
        class="modal-box contract-modal relative z-2 w-[min(468px,calc(100vw-56px))] max-w-none max-h-[calc(100vh-32px)] overflow-y-auto bg-(--surface) p-5.25 rounded-[13px] shadow-[0_9px_30px_#1b34232b] max-[680px]:p-4 [&_form]:grid [&_form]:gap-3.25 [&_.input]:h-9 [&_.input]:min-h-9 [&_.input]:border-(--line) [&_.input]:rounded-[7px] [&_.input]:bg-(--surface) [&_.input]:shadow-[none] [&_.input]:text-[14px] [&_.input]:text-(--ink) [&_.select]:h-9 [&_.select]:min-h-9 [&_.select]:border-(--line) [&_.select]:rounded-[7px] [&_.select]:bg-(--surface) [&_.select]:shadow-[none] [&_.select]:text-[14px] [&_.select]:text-(--ink)"
      >
        <div
          class="modal-heading flex items-start justify-between mb-4.5 [&_>_div]:flex [&_>_div]:items-center [&_>_div]:gap-2.5 [&_h3]:[font:700_15px_Roboto] [&_h3]:m-0 [&_p]:text-[14px] [&_p]:text-[#929d94] [&_p]:m-[4px_0_0]"
        >
          <div>
            <span
              class="modal-icon grid place-items-center w-8.75 h-8.75 rounded-[10px] bg-[#edf4ed] text-[#3b7754]"
              ><AppIcon name="file-plus" :size="20"
            /></span>
            <div>
              <h3>Tạo hợp đồng mới</h3>
              <p>Nhập thông tin cơ bản để bắt đầu.</p>
            </div>
          </div>
          <button class="btn btn-ghost btn-square" aria-label="Đóng" @click="modalOpen = false">
            <AppIcon name="close" :size="17" />
          </button>
        </div>
        <form @submit.prevent="createContract">
          <label
            class="form-control grid gap-1.5 [&_.label-text]:text-[14px] [&_.label-text]:font-bold [&_.label-text]:text-[#637167]"
            ><span class="label-text">Khách hàng</span
            ><input
              v-model="newContract.customer"
              class="input input-bordered"
              placeholder="Tên khách hàng"
              required /></label
          ><label
            class="form-control grid gap-1.5 [&_.label-text]:text-[14px] [&_.label-text]:font-bold [&_.label-text]:text-[#637167]"
            ><span class="label-text">Loại hợp đồng</span
            ><select v-model="newContract.type" class="select select-bordered">
              <option>Cầm đồ</option>
              <option>Tín chấp</option>
              <option>Trả góp</option>
            </select></label
          ><label
            class="form-control grid gap-1.5 [&_.label-text]:text-[14px] [&_.label-text]:font-bold [&_.label-text]:text-[#637167]"
            ><span class="label-text">Tài sản cầm cố</span
            ><input
              v-model="newContract.asset"
              class="input input-bordered"
              placeholder="Ví dụ: Điện thoại, xe máy, vàng"
              required /></label
          ><label
            class="form-control grid gap-1.5 [&_.label-text]:text-[14px] [&_.label-text]:font-bold [&_.label-text]:text-[#637167]"
            ><span class="label-text">Số tiền cho vay</span>
            <div
              class="money-input relative [&_.input]:w-full [&_.input]:pr-12.5 [&_span]:absolute [&_span]:right-2.75 [&_span]:top-2.75 [&_span]:text-[#919c93] [&_span]:text-[14px]"
            >
              <input
                v-model="newContract.amount"
                class="input input-bordered"
                inputmode="numeric"
                type="number"
                min="1"
                placeholder="0"
                required
              /><span>VNĐ</span>
            </div></label
          >
          <div
            class="modal-actions flex justify-end gap-2 mt-1.25 [&_.btn]:h-8.5 [&_.btn]:min-h-8.5 [&_.btn]:text-[14px] [&_.btn-primary]:bg-[#315d46] [&_.btn-primary]:border-[#315d46]"
          >
            <button type="button" class="btn btn-ghost" @click="modalOpen = false">Hủy</button
            ><button type="submit" class="btn btn-primary">
              <AppIcon name="check" :size="15" /> Lưu hợp đồng
            </button>
          </div>
        </form>
      </div>
      <div
        class="modal-backdrop fixed inset-0 pointer-events-none [&_button]:pointer-events-auto [&_button]:absolute [&_button]:w-full [&_button]:h-full [&_button]:opacity-0 [&_button]:cursor-default bg-transparent"
        @click="modalOpen = false"
      ></div>
    </div>

    <Transition
      name="toast"
      enter-active-class="transition-[opacity_0.18s,_transform_0.18s]"
      leave-active-class="transition-[opacity_0.18s,_transform_0.18s]"
      enter-from-class="opacity-0 [transform:translate(-50%,8px)]"
      leave-to-class="opacity-0 [transform:translate(-50%,8px)]"
      ><div
        v-if="toast"
        role="status"
        class="toast-message fixed z-40 bottom-5.5 left-[calc(50%+125px)] transform-[translateX(-50%)] p-[10px_14px] rounded-lg bg-[#273e32] text-[#f6faf5] shadow-[0_9px_30px_#1b34232b] flex items-center gap-2 text-[14px] max-[680px]:left-1/2 max-[680px]:bottom-3.25 max-[680px]:max-w-[calc(100vw-26px)] max-[680px]:whitespace-nowrap max-[680px]:text-[14px]"
      >
        <span
          class="toast-check w-4.75 h-4.75 grid place-items-center rounded-full bg-[#ffffff20] text-[#e1cc78]"
          ><AppIcon name="check" :size="14" /></span
        >{{ toast }}
      </div></Transition
    >
  </div>
</template>
