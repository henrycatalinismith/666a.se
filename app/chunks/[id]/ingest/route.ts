import { NextResponse } from 'next/server'

import { requireUser } from '../../../../lib/authentication'
import prisma from '../../../../lib/database'
import { ingestChunk } from '../../../../lib/ingestion'

export async function POST(request: Request) {
  const user = await requireUser()
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const match = request.url.match(/chunks\/(.+)\/ingest/)
  const id = match![1]!

  const pendingChunk = await prisma.chunk.findFirstOrThrow({
    where: {
      id,
    },
  })

  const ingestedChunk = await ingestChunk(pendingChunk.id)

  return NextResponse.json({
    id: ingestedChunk.id,
    stubCount: ingestedChunk.stubCount,
  })
}
