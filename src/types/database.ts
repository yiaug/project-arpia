export type UserRole = 'pending' | 'approved' | 'admin'
export type UserStatus = 'pending' | 'approved' | 'rejected' | 'inactive'

export interface Profile {
  id: string
  full_name: string
  email: string
  role: UserRole
  status: UserStatus
  avatar_url: string | null
  bio: string | null
  created_at: string
  updated_at: string
}

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: Profile
        Insert: Omit<Profile, 'created_at' | 'updated_at'>
        Update: Partial<Omit<Profile, 'id' | 'created_at' | 'updated_at'>>
      }
    }
  }
}
