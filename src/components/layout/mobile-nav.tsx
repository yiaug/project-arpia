'use client'

import { useState } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { Menu } from 'lucide-react'
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
import { Button } from '@/components/ui/button'
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet'
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

export function MobileNav() {
  const [open, setOpen] = useState(false)
  const pathname = usePathname()
  const { isAdmin } = useAuthContext()

  const navItems = isAdmin ? adminNavItems : userNavItems

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <Button variant="ghost" className="mr-2 px-0 text-base hover:bg-transparent focus-visible:bg-transparent focus-visible:ring-0 focus-visible:ring-offset-0 md:hidden">
          <Menu className="h-5 w-5" />
          <span className="sr-only">Toggle Menu</span>
        </Button>
      </SheetTrigger>
      <SheetContent side="left" className="pr-0">
        <Link
          href="/"
          className="flex items-center"
          onClick={() => setOpen(false)}
        >
          <span className="font-bold">Arpia</span>
        </Link>
        <nav className="flex flex-col gap-2 py-4">
          {navItems.map((item) => {
            const Icon = item.icon
            const isActive = pathname === item.href
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setOpen(false)}
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
      </SheetContent>
    </Sheet>
  )
}
