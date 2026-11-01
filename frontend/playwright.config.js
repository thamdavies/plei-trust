import { defineConfig, devices } from '@playwright/test'

const frontendUrl = 'http://127.0.0.1:5174'
const backendUrl = 'http://127.0.0.1:3100'

export default defineConfig({
  testDir: './e2e',
  fullyParallel: false,
  workers: 1,
  reporter: 'list',
  use: {
    baseURL: frontendUrl,
    trace: 'retain-on-failure',
    ...devices['Desktop Chrome'],
  },
  webServer: [
    {
      command: './bin/e2e-server',
      cwd: '../backend',
      url: `${backendUrl}/api/v1/health`,
      reuseExistingServer: false,
      timeout: 120_000,
      env: {
        RAILS_ENV: 'test',
        FRONTEND_ORIGINS: frontendUrl,
        PGCONNECT_TIMEOUT: '3',
      },
    },
    {
      command: 'pnpm dev --host 127.0.0.1 --port 5174 --strictPort',
      url: frontendUrl,
      reuseExistingServer: false,
      timeout: 120_000,
      env: {
        VITE_API_BASE_URL: backendUrl,
      },
    },
  ],
})
