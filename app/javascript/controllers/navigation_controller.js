import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initTheme();
  }

  toggleSidebar() {
    const hamburgerIcon = document.getElementById('toggleSidebarMobileHamburger');
    const closeIcon = document.getElementById('toggleSidebarMobileClose');
    hamburgerIcon.classList.toggle('hidden');
    closeIcon.classList.toggle('hidden');
    // Add sidebar toggle logic here when sidebar component is created
  }

  toggleTheme() {
    document.documentElement.classList.toggle('dark');
    const isDark = document.documentElement.classList.contains('dark');
    localStorage.setItem('theme', isDark ? 'dark' : 'light');
    this.updateThemeIcons(isDark);
  }

  initTheme() {
    const savedTheme = localStorage.getItem('theme');
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    const isDark = savedTheme === 'dark' || (!savedTheme && prefersDark);
    
    if (isDark) {
      document.documentElement.classList.add('dark');
    }
    this.updateThemeIcons(isDark);
  }

  updateThemeIcons(isDark) {
    const darkIcon = document.getElementById('theme-toggle-dark-icon');
    const lightIcon = document.getElementById('theme-toggle-light-icon');
    if (isDark) {
      darkIcon.classList.add('hidden');
      lightIcon.classList.remove('hidden');
    } else {
      darkIcon.classList.remove('hidden');
      lightIcon.classList.add('hidden');
    }
  }
}
