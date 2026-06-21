import { type NextRequest } from 'next/server'
import { updateSession } from '@/lib/supabase/middleware'

export async function middleware(request: NextRequest) {
  const { supabase, supabaseResponse } = await updateSession(request)

  const {
    data: { user },
  } = await supabase.auth.getUser()

  const pathname = request.nextUrl.pathname

  // Public routes that don't require auth
  const publicRoutes = ['/login', '/register', '/pending']
  const isPublicRoute = publicRoutes.includes(pathname)

  // If not authenticated and trying to access protected route
  if (!user && !isPublicRoute) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return Response.redirect(url)
  }

  // If authenticated, check profile status
  if (user) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('role, status')
      .eq('id', user.id)
      .single()

    // If pending, redirect to pending page
    if (profile?.status === 'pending' && pathname !== '/pending') {
      const url = request.nextUrl.clone()
      url.pathname = '/pending'
      return Response.redirect(url)
    }

    // If rejected or inactive, redirect to login
    if (profile?.status === 'rejected' || profile?.status === 'inactive') {
      await supabase.auth.signOut()
      const url = request.nextUrl.clone()
      url.pathname = '/login'
      return Response.redirect(url)
    }

    // Admin-only routes
    const adminRoutes = ['/admin']
    const isAdminRoute = adminRoutes.some((route) => pathname.startsWith(route))

    if (isAdminRoute && profile?.role !== 'admin') {
      const url = request.nextUrl.clone()
      url.pathname = '/dashboard'
      return Response.redirect(url)
    }

    // If authenticated and on public route, redirect to dashboard
    if (isPublicRoute && profile?.status === 'approved') {
      const url = request.nextUrl.clone()
      url.pathname = '/dashboard'
      return Response.redirect(url)
    }
  }

  return supabaseResponse
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
