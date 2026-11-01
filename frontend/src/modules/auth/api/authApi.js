import { request } from '../../../shared/api/httpClient.js'

export const signIn = (credentials) => request('/session', { method: 'POST', body: credentials })
export const getCurrentUser = () => request('/me')
export const signOut = () => request('/session', { method: 'DELETE' })
