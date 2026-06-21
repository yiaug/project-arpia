export const SITE_NAME = 'Arpia'
export const SITE_DESCRIPTION = 'Plataforma de Estudos Esotéricos'

export const ROUTES = {
  HOME: '/',
  LOGIN: '/login',
  REGISTER: '/register',
  PENDING: '/pending',
  DASHBOARD: '/dashboard',
  PROFILE: '/profile',
  ADMIN: '/admin',
} as const

export const ROLES = {
  PENDING: 'pending',
  APPROVED: 'approved',
  ADMIN: 'admin',
} as const
