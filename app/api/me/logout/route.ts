import { SessionStatus } from '@prisma/client'
import { NextResponse } from 'next/server'

import { sessionUser } from 'lib/authentication'
import prisma from 'lib/database'

export async function POST() {
  const session = await sessionUser()
  if (!session) {
    return NextResponse.json({ status: 'error' })
  }

  await prisma.session.update({
    data: { status: SessionStatus.Revoked },
    where: { id: session.id },
  })

  const response = NextResponse.json({ status: 'success' })
  response.cookies.set('session', '')
  return response
}
