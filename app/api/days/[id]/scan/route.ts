import { RoleName, ScanStatus } from '@prisma/client'
import { inngest } from 'inngest/client'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { NextResponse } from 'next/server'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/days\/(.+)\//)![1]
  const day = await prisma.day.findFirstOrThrow({
    where: { id },
  })

  const scan = await prisma.scan.create({
    data: {
      dayId: day.id,
      status: ScanStatus.ONGOING,
    },
  })

  await inngest.send({
    name: '666a/scan.created',
    data: {
      id: scan.id,
      date: day.date.toISOString().substring(0, 10),
    },
  })

  return NextResponse.json([
    {
      status: 'success',
    },
  ])
}
