import { Chunk, ChunkStatus, ScanStatus, StubStatus } from '@prisma/client'

import { updateChunk } from './chunk'
import prisma from './database'
import { fetchDocument, searchDiarium } from './diarium'
import { createDocument } from './document'
import { createStubs } from './stub'

export async function ingestChunk(chunkId: string): Promise<Chunk> {
  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id: chunkId },
    include: { county: true },
  })

  console.log(`[ingestChunk]: ${chunk.id} ${chunk.county.name}`)

  const result = await searchDiarium({
    SelectedCounty: chunk.county.code,
    sortDirection: 'Asc',
    sortOrder: 'Dokumentdatum',
    page: chunk.page,
  })

  console.log(
    `[ingestChunk]: ${chunk.id} ${result.rows.length} ${result.hitCount}`
  )

  const stubs = await createStubs(chunk.id, result)
  const startDate = chunk.startDate ?? stubs[0].documentDate

  await prisma.scan.update({
    where: { id: chunk.scanId },
    data: { status: ScanStatus.ONGOING },
  })

  return await updateChunk(chunk.id, {
    hitCount: result.hitCount,
    startDate,
    stubCount: stubs.length,
    status: ChunkStatus.ONGOING,
  })
}

export async function ingestStub(stubId: string): Promise<void> {
  const stub = await prisma.stub.findFirstOrThrow({
    where: { id: stubId, status: StubStatus.PENDING },
  })

  const diariumDocument = await fetchDocument(stub.documentCode)
  const doc = await createDocument(diariumDocument)

  await prisma.stub.update({
    data: { status: StubStatus.SUCCESS, documentId: doc.id },
    where: { id: stub.id },
  })

  const uningestedSiblings = await prisma.stub.count({
    where: {
      chunkId: stub.chunkId,
      status: {
        in: [StubStatus.PENDING, StubStatus.FAILURE],
      },
    },
  })
  console.log(uningestedSiblings)
  if (uningestedSiblings === 0) {
    await prisma.chunk.update({
      where: { id: stub.chunkId },
      data: { status: ChunkStatus.SUCCESS, updated: new Date() },
    })
  }
}
