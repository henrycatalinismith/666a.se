import { ChunkStatus, RoleName } from '@prisma/client'
import { inngest } from 'inngest/client'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { searchDiarium } from 'lib/diarium'
import _ from 'lodash'
import { NextResponse } from 'next/server'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/scans\/(.+)\//)![1]
  const scan = await prisma.scan.findFirstOrThrow({
    where: { id },
    include: { day: true },
  })

  const result = await searchDiarium({
    FromDate: scan.day.date.toISOString().substring(0, 10),
    ToDate: scan.day.date.toISOString().substring(0, 10),
  })

  const fullResult = result.hitCount.match(/^(\d+) träffar$/)
  const stubsPerChunk = 10
  let targetStubCount = 0
  if (fullResult) {
    targetStubCount = parseInt(fullResult[1], 10)
  }
  const targetChunkCount = targetStubCount / stubsPerChunk + 1

  await prisma.chunk.createMany({
    data: _.times(targetChunkCount, (index) => ({
      status: ChunkStatus.PENDING,
      scanId: id,
      page: index + 1,
    })),
  })

  const chunks = await prisma.chunk.findMany({
    where: { scanId: id },
  })

  const next = await prisma.chunk.findFirstOrThrow({
    where: { scanId: scan.id },
    orderBy: { page: 'asc' },
  })

  await prisma.chunk.update({
    data: { status: ChunkStatus.ONGOING },
    where: { id: next.id },
  })

  await inngest.send({
    name: '666a/chunk.started',
    data: {
      id: next.id,
      date: scan.day.date.toISOString().substring(0, 10),
      page: next.page,
    },
    user: {},
  })

  return NextResponse.json([
    {
      status: 'success',
      chunks: _.map(chunks, 'id'),
    },
  ])
}
