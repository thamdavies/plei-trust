import js from '@eslint/js'
import eslintConfigPrettier from 'eslint-config-prettier/flat'
import globals from 'globals'
import pluginVue from 'eslint-plugin-vue'

export default [
  { ignores: ['dist/**', 'build/**', 'coverage/**', 'node_modules/**', '**/*.min.js'] },
  js.configs.recommended,
  ...pluginVue.configs['flat/recommended'],
  {
    files: ['src/**/*.{js,vue}'],
    languageOptions: {
      globals: globals.browser,
    },
  },
  {
    files: ['*.{js,mjs,cjs}'],
    languageOptions: {
      globals: globals.node,
    },
  },
  {
    files: ['e2e/**/*.{js,mjs,cjs}'],
    languageOptions: {
      globals: globals.node,
    },
  },
  eslintConfigPrettier,
]
