import { toTypedSchema } from '@vee-validate/zod'
import { z } from 'zod'

export const signInZodSchema = z.object({
  username: z.string().trim().min(1, 'Vui lòng nhập tên đăng nhập.'),
  password: z.string().min(1, 'Vui lòng nhập mật khẩu.'),
})

export const signInSchema = toTypedSchema(signInZodSchema)
