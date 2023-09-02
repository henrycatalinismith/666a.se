import { County, Scan } from '@prisma/client'

import { createInitialChunk, createProjectedChunks } from './chunk'
import { findNewestArtefactDate } from './county'
import prisma from './database'
import { ingestChunk } from './ingestion'

const stubsPerChunk = 10

export async function scanCounty(countyId: string): Promise<Scan> {
  const county = await prisma.county.findFirstOrThrow({
    where: { id: countyId },
  })

  const ongoingScan = await findOngoingScan(county)
  if (ongoingScan) {
    return ongoingScan
  }

  const scan = await createScan(county)
  const pendingChunk = await createInitialChunk(scan.id)
  const ingestedChunk = await ingestChunk(pendingChunk.id)
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

export async function findOngoingScan(county: County): Promise<Scan | null> {
  return await prisma.scan.findFirst({
    where: {
      countyId: county.id,
      completed: null,
    },
  })
}

export async function createScan(county: County): Promise<Scan> {
  const now = new Date()
  const startDate = await findNewestArtefactDate(county.id)
  console.log('hello')
  console.log({ startDate })
  return await prisma.scan.create({
    data: {
      countyId: county.id,
      chunkCount: 0,
      startDate,
      completed: null,
      created: now,
      updated: now,
    },
  })
}
