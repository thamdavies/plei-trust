import { createRouter, createWebHistory } from 'vue-router'
import DashboardView from './views/DashboardView.vue'

const sections = [
  { path: '/', label: 'Tổng quan' },
  { path: '/contracts/pawn', label: 'Hợp đồng cầm đồ' },
  { path: '/contracts/credit', label: 'Hợp đồng tín chấp' },
  { path: '/contracts/installment', label: 'Hợp đồng trả góp' },
  { path: '/customers', label: 'Khách hàng' },
  { path: '/collaborators', label: 'Cộng tác viên' },
  { path: '/finance/fund', label: 'Sổ quỹ' },
  { path: '/finance/transactions', label: 'Thu chi' },
  { path: '/reports', label: 'Báo cáo' },
]

export default createRouter({
  history: createWebHistory(),
  routes: sections.map(({ path, label }) => ({
    path,
    name: path === '/' ? 'dashboard' : path.slice(1).replaceAll('/', '-'),
    component: DashboardView,
    meta: { label },
  })),
})
