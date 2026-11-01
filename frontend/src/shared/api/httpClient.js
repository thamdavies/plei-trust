const apiBaseUrl = (import.meta.env?.VITE_API_BASE_URL || '').replace(/\/$/, '')

export class ApiError extends Error {
  constructor(message, { status, code, retryAfter, cause } = {}) {
    super(message, { cause })
    this.name = 'ApiError'
    this.status = status
    this.code = code
    this.retryAfter = retryAfter
  }
}

export async function request(path, { method = 'GET', body, headers = {} } = {}) {
  let response
  try {
    response = await fetch(`${apiBaseUrl}/api/v1${path}`, {
      method,
      credentials: 'include',
      headers: { Accept: 'application/json', ...(body ? { 'Content-Type': 'application/json' } : {}), ...headers },
      ...(body ? { body: JSON.stringify(body) } : {}),
    })
  } catch (cause) {
    throw new ApiError('Không thể kết nối máy chủ. Vui lòng thử lại.', { cause })
  }

  if (response.status === 204) return null
  const payload = await response.json().catch(() => ({}))
  if (!response.ok) {
    const error = payload.error || {}
    const retryAfter = Number(response.headers.get('Retry-After')) || undefined
    throw new ApiError(error.message || 'Đã xảy ra lỗi. Vui lòng thử lại.', {
      status: response.status,
      code: error.code,
      retryAfter,
    })
  }
  return payload
}
