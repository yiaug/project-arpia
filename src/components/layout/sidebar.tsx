'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import {
  BookOpen,
  Headphones,
  MessageSquare,
  MessageCircle,
  Sparkles,
  LayoutDashboard,
  Users,
  Tag,
} from 'lucide-react'
import { useAuthContext } from '@/components/auth/auth-provider'
import { cn } from '@/lib/utils'

const userNavItems = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/books', label: 'Biblioteca', icon: BookOpen },
  { href: '/audiobooks', label: 'Audiolivros', icon: Headphones },
  { href: '/forum', label: 'Fórum', icon: MessageSquare },
  { href: '/chat', label: 'Chat', icon: MessageCircle },
  { href: '/tarot', label: 'Tarô', icon: Sparkles },
]

const adminNavItems = [
  { href: '/admin', label: 'Dashboard Admin', icon: LayoutDashboard },
  { href: '/admin/users', label: 'Usuários', icon: Users },
  { href: '/admin/books', label: 'Livros', icon: BookOpen },
  { href: '/admin/audiobooks', label: 'Audiolivros', icon: Headphones },
  { href: '/admin/categories', label: 'Categorias', icon: Tag },
  { href: '/admin/forum', label: 'Fórum', icon: MessageSquare },
  { href: '/admin/chat', label: 'Chat', icon: MessageCircle },
  { href: '/admin/tarot', label: 'Tarô', icon: Sparkles },
]

export function Sidebar() {
  const pathname = usePathname()
  const { isAdmin } = useAuthContext()

  const navItems = isAdmin ? adminNavItems : userNavItems

  return (
    <aside className="hidden w-56 shrink-0 border-r md:block">
      <nav className="flex flex-col gap-1 p-4">
        {navItems.map((item) => {
          const Icon = item.icon
          const isActive = pathname === item.href || pathname.startsWith(item.href + '/')
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground',
                isActive
                  ? 'bg-accent text-accent-foreground'
                  : 'text-muted-foreground'
              )}
            >
              <Icon className="h-4 w-4" />
              {item.label}
            </Link>
          )
        })}
      </nav>
    </aside>
  )
}
