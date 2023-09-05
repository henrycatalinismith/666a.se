import { Chunk, ChunkStatus, ScanStatus, StubStatus } from '@prisma/client'

import { updateChunk } from './chunk'
import prisma, { Transaction } from './database'
import { fetchDocument, searchDiarium } from './diarium'
import { createDocument } from './document'
import { createStubs } from './stub'

export async function ingestChunk(
  chunkId: string,
  tx: Transaction
): Promise<Chunk> {
  const chunk = await tx.chunk.findFirstOrThrow({
    where: { id: chunkId },
    include: { county: true },
  })

  console.log(`[ingestChunk]: ${chunkId} ${chunk.county.name}`)

  const result = await searchDiarium({
    SelectedCounty: chunk.county.code,
    sortDirection: 'Asc',
    sortOrder: 'Dokumentdatum',
    page: chunk.page,
  })

  console.log(
    `[ingestChunk]: ${chunk.id} ${result.rows.length} ${result.hitCount}`
  )

  const stubs = await createStubs(chunk.id, result, tx)
  const startDate = chunk.startDate ?? stubs[0].documentDate

  await tx.scan.update({
    where: { id: chunk.scanId },
    data: { status: ScanStatus.ONGOING },
  })

  return await updateChunk(
    chunk.id,
    {
      hitCount: result.hitCount,
      startDate,
      stubCount: stubs.length,
      status: ChunkStatus.ONGOING,
    },
    tx
  )
}

export async function ingestStub(
  stubId: string,
  tx: Transaction
): Promise<void> {
  const stub = await tx.stub.findFirstOrThrow({
    where: { id: stubId, status: StubStatus.PENDING },
  })

  const diariumDocument = await fetchDocument(stub.documentCode)
  const doc = await createDocument(diariumDocument, tx)

  await tx.stub.update({
    data: { status: StubStatus.SUCCESS, documentId: doc.id },
    where: { id: stub.id },
  })

  const uningestedSiblings = await tx.stub.count({
    where: {
      chunkId: stub.chunkId,
      status: {
        in: [StubStatus.PENDING, StubStatus.FAILURE],
      },
    },
  })
  if (uningestedSiblings === 0) {
    await tx.chunk.update({
      where: { id: stub.chunkId },
      data: { status: ChunkStatus.SUCCESS, updated: new Date() },
    })
  }
}
