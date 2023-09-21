import { RoleName } from '@prisma/client'
import { NextResponse } from 'next/server'

import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'

export async function PUT(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/subscriptions\/(.+)/)![1]
  await prisma.subscription.findFirstOrThrow({
    where: { id },
  })

  const { companyCode } = await request.json()
  await prisma.subscription.update({
    data: { companyCode },
    where: { id },
  })

  return NextResponse.json([
    {
      status: 'success',
    },
  ])
}
