import { Chunk, ChunkStatus, ScanStatus } from '@prisma/client'

import { Transaction } from './database'

export async function updateChunk(
  id: string,
  data: Partial<Chunk>,
  tx: Transaction
): Promise<Chunk> {
  const before = await tx.chunk.findFirstOrThrow({
    where: { id },
  })

  const after = await tx.chunk.update({
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
    await tx.scan.update({
      where: { id: before.scanId },
      data: { startDate: after.startDate, updated: new Date() },
    })
  }

  // Each time a chunk is ingested there's a chance it's the last missing chunk
  // within its scan. After the final chunk for a scan is ingested, the scan is
  // marked as completed.
  if (
    before.status === ChunkStatus.ONGOING &&
    after.status === ChunkStatus.SUCCESS
  ) {
    const uningestedSiblings = await tx.chunk.count({
      where: {
        scanId: before.scanId,
        status: {
          in: [ChunkStatus.PENDING, ChunkStatus.ONGOING, ChunkStatus.FAILURE],
        },
      },
    })
    if (uningestedSiblings === 0) {
      await tx.scan.update({
        where: { id: before.scanId },
        data: { status: ScanStatus.SUCCESS, updated: new Date() },
      })
    }
  }

  return after
}
