import { createApp } from 'vue'
import App from './app/App.vue'
import router, { pinia } from './app/router'
import './style.css'

createApp(App).use(pinia).use(router).mount('#app')
