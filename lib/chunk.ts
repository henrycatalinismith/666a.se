import { Chunk, Scan } from '@prisma/client'
import _ from 'lodash'

import prisma from './database'

export async function createInitialChunk(scanId: string): Promise<Chunk> {
  const now = new Date()

  const scan = await prisma.scan.findFirstOrThrow({ where: { id: scanId } })

  const chunk = await prisma.chunk.create({
    data: {
      scanId: scanId,
      countyId: scan.countyId,
      startDate: scan.startDate,
      stubCount: null,
      page: 1,
      created: now,
      updated: now,
    },
  })

  await prisma.scan.update({
    where: { id: scanId },
    data: { chunkCount: { increment: 1 } },
  })

  return chunk
}

export async function createProjectedChunks(
  scanId: string,
  targetChunkCount: number
): Promise<void> {
  const scan = await prisma.scan.findFirstOrThrow({ where: { id: scanId } })
  const now = new Date()
  const result = await prisma.chunk.createMany({
    data: _.times(targetChunkCount, (index) => ({
      scanId: scan.id,
      countyId: scan.countyId,
      startDate: scan.startDate,
      page: index + 2,
      stubCount: null,
      created: now,
      updated: now,
    })),
  })

  await prisma.scan.update({
    where: { id: scanId },
    data: { chunkCount: { increment: result.count } },
  })
}

export async function updateChunk(
  id: string,
  data: Partial<Chunk>
): Promise<Chunk> {
  const before = await prisma.chunk.findFirstOrThrow({
    where: { id },
  })

  const after = await prisma.chunk.update({
    where: { id },
    data: {
      ...data,
      updated: new Date(),
    },
  })

  if (
    before.startDate === null &&
    after.startDate !== null &&
    before.page === 1
  ) {
    await prisma.scan.update({
      where: { id: before.scanId },
      data: { startDate: after.startDate, updated: new Date() },
    })
  }

  // Each time a chunk is ingested there's a chance it's the last missing chunk
  // within its scan. After the final chunk for a scan is ingested, the scan is
  // marked as completed.
  if (before.ingested === null && after.ingested !== null) {
    const uningestedSiblings = await prisma.chunk.count({
      where: {
        scanId: before.scanId,
        ingested: { not: null },
      },
    })
    if (uningestedSiblings === 0) {
      await prisma.scan.update({
        where: { id: before.scanId },
        data: { completed: new Date(), updated: new Date() },
      })
    }
  }

  return after
}
