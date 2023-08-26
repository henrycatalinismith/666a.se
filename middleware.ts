import { NextResponse } from 'next/server'

import { findSessionBySecret } from './lib/session'

import type { NextRequest } from 'next/server'

function requiresLogin(path: string): boolean {
  if (path.match(/\/(companies|cases)/)) {
    return true
  }

  return false
}

export function middleware(request: NextRequest) {
  const secret = request.cookies.get('session')?.value
  const session = secret ? findSessionBySecret({ secret }) : undefined
  requiresLogin(request.url)
  if (!session && requiresLogin(request.url)) {
    return NextResponse.rewrite(new URL('/login', request.url))
  }
}

export const config = {
  matcher: ['/', '/companies/:code*'],
}
