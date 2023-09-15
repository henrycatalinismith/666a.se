import { ChunkStatus, RoleName, StubStatus } from '@prisma/client'
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

  const id = request.url!.match(/chunks\/(.+)\//)![1]
  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id },
    include: { scan: { include: { day: true } } },
  })

  const result = await searchDiarium({
    FromDate: chunk.scan.day.date.toISOString().substring(0, 10),
    ToDate: chunk.scan.day.date.toISOString().substring(0, 10),
    page: chunk.page,
  })

  const documents = await prisma.document.findMany({
    where: {
      code: {
        in: result.rows.map((r) => r.documentCode),
      },
    },
  })
  const documentCodes = documents.map((d) => d.code)
  const newDocuments = result.rows.filter((row) => {
    return !documentCodes.includes(row.documentCode)
  })

  const now = new Date()
  const newStubs = await prisma.stub.createMany({
    data: newDocuments.map((row, index) => ({
      chunkId: chunk.id,
      index,
      status: StubStatus.PENDING,
      caseName: row.caseName,
      documentCode: row.documentCode,
      documentDate: new Date(row.documentDate),
      documentType: row.documentType,
      companyName: row.companyName,
      created: now,
      updated: now,
    })),
  })

  const stubs = await prisma.stub.findMany({
    where: { chunkId: chunk.id },
  })

  await inngest.send(
    stubs.map((stub) => ({
      name: '666a/stub.created',
      data: {
        id: stub.id,
        date: chunk.scan.day.date.toISOString().substring(0, 10),
        index: stub.index,
      },
    }))
  )

  await prisma.chunk.update({
    where: { id: chunk.id },
    data: {
      hitCount: result.hitCount,
      newCount: newDocuments.length,
      stubCount: newStubs.count,
      status:
        result.rows.length > 0 && newDocuments.length > 0
          ? ChunkStatus.ONGOING
          : ChunkStatus.SUCCESS,
    },
  })

  return NextResponse.json([
    {
      status: 'success',
      chunks: _.map(stubs, 'id'),
    },
  ])
}
