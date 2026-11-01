<script setup>
import {
  ArrowLeftRight,
  ArrowRight,
  ArrowUpRight,
  Bell,
  CalendarDays,
  ChartNoAxesColumnIncreasing,
  Check,
  ChevronDown,
  ChevronsUpDown,
  Coins,
  Ellipsis,
  FilePlus2,
  FileText,
  HandCoins,
  LayoutGrid,
  ListFilter,
  LogOut,
  Menu,
  Moon,
  Plus,
  Search,
  ShieldCheck,
  Sun,
  UsersRound,
  UserRoundPlus,
  Wallet,
  X,
} from '@lucide/vue'

const props = defineProps({
  name: { type: String, required: true },
  size: { type: Number, default: 20 },
})

const icons = {
  grid: LayoutGrid,
  safe: Wallet,
  hand: HandCoins,
  calendar: CalendarDays,
  users: UsersRound,
  'user-plus': UserRoundPlus,
  wallet: Wallet,
  arrows: ArrowLeftRight,
  chart: ChartNoAxesColumnIncreasing,
  file: FileText,
  coins: Coins,
  chevrons: ChevronsUpDown,
  chevron: ChevronDown,
  'arrow-up': ArrowUpRight,
  'arrow-right': ArrowRight,
  shield: ShieldCheck,
  more: Ellipsis,
  menu: Menu,
  search: Search,
  moon: Moon,
  sun: Sun,
  bell: Bell,
  close: X,
  filter: ListFilter,
  plus: Plus,
  'file-plus': FilePlus2,
  'log-out': LogOut,
  check: Check,
}
</script>

<template>
  <component
    :is="icons[props.name] || LayoutGrid"
    :size="props.size"
    :stroke-width="1.7"
    aria-hidden="true"
  />
</template>
