import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export async function POST(request: any) {
  const user = await requireUser()
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const subscriptionCount = await prisma.subscription.count({
    where: { userId: user.id },
  })
  if (subscriptionCount > 0) {
    return NextResponse.json({ status: 'failure' })
  }

  const { companyCode } = await request.json()
  const subscription = await prisma.subscription.create({
    data: {
      companyCode,
      userId: user.id,
    },
  })

  return NextResponse.json([
    {
      status: 'success',
      id: subscription.id,
    },
  ])
}
