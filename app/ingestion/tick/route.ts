import { NextResponse } from 'next/server'

import { requireUser } from '../../../lib/authentication'
// import prisma from '../../../lib/database'

export async function POST() {
  const user = await requireUser()
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  return NextResponse.json([
    {
      lol: true,
    },
  ])
}
