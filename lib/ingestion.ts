import { Chunk, County, Scan, Stub } from '@prisma/client'

import { createInitialChunk, createProjectedChunks, updateChunk } from './chunk'
import prisma from './database'
import { searchDiarium } from './diarium'
import { createScan, findOngoingScan } from './scan'
import { createStubs } from './stub'

const stubsPerChunk = 10

export async function scanCounty(county: County): Promise<Scan> {
  const ongoingScan = await findOngoingScan(county)
  if (ongoingScan) {
    return ongoingScan
  }

  const scan = await createScan(county)
  const pendingChunk = await createInitialChunk(scan.id)
  const ingestedChunk = await ingestChunk(pendingChunk)
  console.log(ingestedChunk.hitCount)

  const limitedResult = ingestedChunk!.hitCount!.match(
    /^Visar (\d+) av (\d+) träffar$/
  )
  if (limitedResult) {
    const targetStubCount = parseInt(limitedResult[1], 10) - stubsPerChunk
    const targetChunkCount = targetStubCount / stubsPerChunk
    await createProjectedChunks(scan.id, targetChunkCount)
  }

  return scan
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestChunk(chunk: Chunk): Promise<Chunk> {
  const scan = await prisma.scan.findFirstOrThrow({
    where: { id: chunk.scanId },
  })

  const county = await prisma.county.findFirstOrThrow({
    where: { id: scan.countyId },
  })

  console.log(`[ingestChunk]: ${chunk.id} ${county.name}`)

  const result = await searchDiarium({
    SelectedCounty: county.code,
    sortDirection: 'Asc',
    sortOrder: 'Dokumentdatum',
    page: chunk.page,
  })

  console.log(
    `[ingestChunk]: ${chunk.id} ${result.rows.length} ${result.hitCount}`
  )

  const stubs = await createStubs(chunk.id, result)
  const startDate = chunk.startDate ?? stubs[0].filed
  return await updateChunk(chunk.id, {
    hitCount: result.hitCount,
    startDate,
    stubCount: stubs.length,
    ingested: new Date(),
  })
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export async function ingestStub(stub: Stub): Promise<void> {
  // send request
  // create document from response
  // mark stub as ingested
}
