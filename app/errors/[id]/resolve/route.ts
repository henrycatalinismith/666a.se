import { ErrorStatus } from '@prisma/client'
import { NextResponse } from 'next/server'

import { requireUser } from '../../../../lib/authentication'
import prisma from '../../../../lib/database'

export async function POST(request: any) {
  const user = await requireUser()
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/errors\/(.+)\/resolve/)![1]
  await prisma.error.findFirstOrThrow({
    where: { id },
  })

  await prisma.error.update({
    where: { id },
    data: { status: ErrorStatus.RESOLVED },
  })

  return NextResponse.json([
    {
      lol: true,
    },
  ])
}
