import { Chunk, Scan } from '@prisma/client'

import prisma from './database'

export async function createChunk(scan: Scan): Promise<Chunk> {
  const now = new Date()
  return await prisma.chunk.create({
    data: {
      scanId: scan.id,
      startDate: null,
      stubCount: null,
      created: now,
      updated: now,
    },
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
