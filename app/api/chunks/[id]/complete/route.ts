import { ChunkStatus, RoleName } from '@prisma/client'
import { inngest } from 'inngest/client'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { NextResponse } from 'next/server'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/chunks\/(.+)\//)![1]
  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id },
    include: { scan: { include: { day: true } } },
  })

  console.log(chunk)
  await prisma.chunk.update({
    data: { status: ChunkStatus.SUCCESS },
    where: { id },
  })

  const next = await prisma.chunk.findFirst({
    where: {
      scanId: chunk.scanId,
      status: ChunkStatus.PENDING,
    },
    orderBy: { page: 'asc' },
    include: { scan: { include: { day: true } } },
  })

  if (next) {
    await prisma.chunk.update({
      data: { status: ChunkStatus.ONGOING },
      where: { id: next.id },
    })

    await inngest.send({
      name: '666a/chunk.started',
      data: {
        id: next.id,
        date: next.scan.day.date.toISOString().substring(0, 10),
        page: next.page,
      },
    })
  } else {
    await inngest.send({
      name: '666a/scan.completed',
      data: {
        id: chunk.scan.id,
      },
    })
  }

  return NextResponse.json([
    {
      status: 'success',
    },
  ])
}
