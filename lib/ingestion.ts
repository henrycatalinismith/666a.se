import { Chunk, County, Scan, Stub } from '@prisma/client'

import { createInitialChunk, createProjectedChunks, updateChunk } from './chunk'
import prisma from './database'
import { fetchDocument, searchDiarium } from './diarium'
import { createDocument } from './document'
import { createScan, findOngoingScan } from './scan'
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
  return await updateChunk(chunk.id, {
    hitCount: result.hitCount,
    startDate,
    stubCount: stubs.length,
    ingested: new Date(),
  })
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestStub(stubId: string): Promise<void> {
  const stub = await prisma.stub.findFirstOrThrow({
    where: { id: stubId, ingested: null },
  })

  const diariumDocument = await fetchDocument(stub.documentCode)
  await createDocument(diariumDocument)

  await prisma.stub.update({
    data: { ingested: new Date() },
    where: { id: stub.id },
  })

  // send request
  // create document from response
  // mark stub as ingested
}
