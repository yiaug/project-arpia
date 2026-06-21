'use client'

import { createContext, useContext } from 'react'
import { useAuth } from '@/hooks/use-auth'
import type { Profile } from '@/types/database'
import type { User } from '@supabase/supabase-js'

interface AuthContextType {
  user: User | null
  profile: Profile | null
  loading: boolean
  signOut: () => Promise<void>
  isAdmin: boolean
  isApproved: boolean
  isPending: boolean
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  profile: null,
  loading: true,
  signOut: async () => {},
  isAdmin: false,
  isApproved: false,
  isPending: false,
})

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const auth = useAuth()

  return (
    <AuthContext.Provider value={auth}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuthContext = () => useContext(AuthContext)
