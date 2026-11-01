import { defineStore } from 'pinia'

export const useDashboardStore = defineStore('dashboard', {
  state: () => ({
    activeMenu: 'Tổng quan',
    darkMode: localStorage.getItem('pawnify-theme') === 'dark',
    contracts: [
      {
        code: 'PF-1042',
        customer: 'Nguyễn Hoàng An',
        phone: '••• •• 3174',
        asset: 'iPhone 15 · 128 GB',
        loan: '12.500.000',
        rate: '45.000/ngày',
        due: '03/11/2026',
        status: 'Sắp đến hạn',
        initials: 'HA',
        avatar: 'avatar-sage',
      },
      {
        code: 'PF-1039',
        customer: 'Lê Bảo Châu',
        phone: '••• •• 7462',
        asset: 'Honda Air Blade 2023',
        loan: '28.000.000',
        rate: '70.000/ngày',
        due: '08/11/2026',
        status: 'Đang vay',
        initials: 'BC',
        avatar: 'avatar-sky',
      },
      {
        code: 'TG-0208',
        customer: 'Trương Văn Nam',
        phone: '••• •• 5501',
        asset: 'Laptop 14 inch',
        loan: '16.000.000',
        rate: 'Trả góp tháng',
        due: '12/11/2026',
        status: 'Đang vay',
        initials: 'VN',
        avatar: 'avatar-rose',
      },
      {
        code: 'PF-1028',
        customer: 'Võ Thanh Tâm',
        phone: '••• •• 9813',
        asset: 'Vàng 9999 · 2 chỉ',
        loan: '16.000.000',
        rate: '55.000/ngày',
        due: '18/11/2026',
        status: 'Đang vay',
        initials: 'TT',
        avatar: 'avatar-gold',
      },
    ],
  }),
  actions: {
    addContract(contract) {
      this.contracts.unshift(contract)
    },
  },
})
