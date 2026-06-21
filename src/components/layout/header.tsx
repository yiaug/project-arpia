'use client'

import Link from 'next/link'
import { LogOut, User } from 'lucide-react'
import { useAuthContext } from '@/components/auth/auth-provider'
import { Button } from '@/components/ui/button'
import { ThemeToggle } from '@/components/theme-toggle'

export function Header() {
  const { user, signOut } = useAuthContext()

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container flex h-14 items-center">
        <Link href="/" className="mr-6 flex items-center space-x-2">
          <span className="hidden font-bold sm:inline-block">
            Arpia
          </span>
        </Link>
        <div className="flex flex-1 items-center justify-between space-x-2 md:justify-end">
          <nav className="flex items-center space-x-2">
            <ThemeToggle />
            {user ? (
              <>
                <Link href="/profile">
                  <Button variant="ghost" size="icon">
                    <User className="h-5 w-5" />
                  </Button>
                </Link>
                <Button variant="ghost" size="icon" onClick={signOut}>
                  <LogOut className="h-5 w-5" />
                </Button>
              </>
            ) : (
              <Link href="/login">
                <Button variant="default" size="sm">
                  Entrar
                </Button>
              </Link>
            )}
          </nav>
        </div>
      </div>
    </header>
  )
}
