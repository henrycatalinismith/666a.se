// import { NextResponse } from 'next/server'

import prisma from './lib/database'

import type { NextRequest } from 'next/server'

// function requiresLogin(path: string): boolean {
//   if (path.match(/\/(companies|cases|dashboard)/)) {
//     return true
//   }

//   return false
// }

export async function middleware(request: NextRequest) {
  // if (!requiresLogin(request.url)) {
  //   return
  // }
  // const secret = request.cookies.get('session')?.value
  // if (!secret) {
  //   return NextResponse.rewrite(new URL('/', request.url))
  // }
  // const session = await prisma.session.findFirst({
  //   where: { secret },
  // })
  // if (!session) {
  //   return NextResponse.rewrite(new URL('/', request.url))
  // }
}

export const config = {
  // matcher: ['/companies/:code*', '/cases/:code*', '/dashboard'],
}
