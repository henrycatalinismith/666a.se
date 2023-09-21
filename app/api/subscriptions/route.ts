import { RoleName } from '@prisma/client'
import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const { userId, companyCode } = await request.json()
  const subscription = await prisma.subscription.create({
    data: {
      userId,
      companyCode,
    },
  })

  return NextResponse.json([
    {
      lol: true,
      id: subscription.id,
    },
  ])
}
