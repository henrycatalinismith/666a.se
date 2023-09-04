import {
  ChunkStatus,
  ErrorStatus,
  ScanStatus,
  StubStatus,
  Tick,
  TickType,
} from '@prisma/client'
import _ from 'lodash'

import prisma from './database'
import { ingestChunk, ingestStub } from './ingestion'

export async function createTick(): Promise<Tick> {
  console.log('creating tick')
  const blockingError = await prisma.error.findFirst({
    where: { status: ErrorStatus.BLOCKING },
  })
  if (blockingError) {
    console.error(blockingError.id)
    console.error(blockingError.message)
    return await prisma.tick.findFirstOrThrow({
      where: { errorId: blockingError.id },
    })
  }

  const stub = await prisma.stub.findFirst({
    where: { status: StubStatus.PENDING },
    orderBy: { created: 'asc' },
  })

  const chunk = await prisma.chunk.findFirst({
    where: { status: { in: [ChunkStatus.PENDING, ChunkStatus.ONGOING] } },
    orderBy: { created: 'asc' },
  })

  const county =
    (await prisma.county.findFirst({
      where: { ticked: null },
      orderBy: { name: 'asc' },
    })) ??
    (await prisma.county.findFirstOrThrow({
      where: { ticked: { not: null } },
      orderBy: { ticked: 'asc' },
    }))

  const tick = stub
    ? await tickStub(stub.id)
    : chunk
    ? await tickChunk(chunk.id)
    : await tickScan(county.id)

  return tick
}

async function tickStub(stubId: string): Promise<Tick> {
  const stub = await prisma.stub.findFirstOrThrow({ where: { id: stubId } })
  const now = new Date()
  const tick = await prisma.tick.create({
    data: {
      created: now,
      updated: now,
      scanId: stub.scanId,
      stubId: stubId,
      type: TickType.STUB,
    },
  })

  try {
    await prisma.$transaction(async (tx) => {
      await ingestStub(stubId, tx)
    })
  } catch (e) {
    const error = await prisma.error.create({
      data: {
        status: ErrorStatus.BLOCKING,
        code: (e as any).code,
        message: (e as any).message,
        stack: (e as any).stack,
      },
    })
    await prisma.tick.update({
      where: { id: tick.id },
      data: { errorId: error.id },
    })
  }

  return tick
}

async function tickChunk(chunkId: string): Promise<Tick> {
  const chunk = await prisma.chunk.findFirstOrThrow({ where: { id: chunkId } })
  const tick = await prisma.tick.create({
    data: {
      scanId: chunk.scanId,
      chunkId: chunkId,
      type: TickType.CHUNK,
    },
  })

  try {
    await prisma.$transaction(async (tx) => {
      await ingestChunk(chunkId, tx)
    })
  } catch (e) {
    const error = await prisma.error.create({
      data: {
        status: ErrorStatus.BLOCKING,
        code: (e as any).code,
        message: (e as any).message,
        stack: (e as any).stack,
      },
    })
    await prisma.tick.update({
      where: { id: tick.id },
      data: { errorId: error.id },
    })
  }

  return tick
}

async function tickScan(countyId: string): Promise<Tick> {
  const tick = await prisma.tick.create({
    data: {
      type: TickType.SCAN,
    },
  })

  try {
    await prisma.$transaction(async (tx) => {
      const incompleteScan = await prisma.scan.findFirst({
        where: {
          countyId: countyId,
          status: { in: [ScanStatus.PENDING, ScanStatus.ONGOING] },
        },
      })

      if (incompleteScan) {
        throw new Error('Cannot initiate new scan while one is ongoing')
      }

      const newestStub = await prisma.stub.findFirst({
        where: {
          countyId: countyId,
        },
        orderBy: {
          documentDate: 'desc',
        },
      })

      const newestDocument = await prisma.document.findFirst({
        where: {
          countyId: countyId,
        },
        orderBy: {
          date: 'desc',
        },
      })

      const newestDate =
        newestStub?.documentDate || newestDocument?.date || null

      const scan = await tx.scan.create({
        data: {
          countyId: countyId,
          chunkCount: 0,
          startDate: newestDate,
          status: ScanStatus.PENDING,
        },
      })

      await tx.tick.update({
        data: { scanId: scan.id },
        where: { id: tick.id },
      })

      await tx.county.update({
        data: { ticked: new Date() },
        where: { id: countyId },
      })

      const stubsPerChunk = 10

      const pendingChunk = await tx.chunk.create({
        data: {
          status: ChunkStatus.ONGOING,
          scanId: scan.id,
          countyId: scan.countyId,
          startDate: scan.startDate,
          stubCount: null,
          page: 1,
        },
      })

      await tx.scan.update({
        where: { id: scan.id },
        data: { chunkCount: { increment: 1 } },
      })

      const ingestedChunk = await ingestChunk(pendingChunk.id, tx)
      console.log(ingestedChunk.hitCount)

      const limitedResult = ingestedChunk!.hitCount!.match(
        /^Visar (\d+) av (\d+) träffar$/
      )
      if (limitedResult) {
        const targetStubCount = parseInt(limitedResult[1], 10) - stubsPerChunk
        const targetChunkCount = targetStubCount / stubsPerChunk

        const projectChunkResult = await tx.chunk.createMany({
          data: _.times(targetChunkCount, (index) => ({
            status: ChunkStatus.PENDING,
            scanId: scan.id,
            countyId: scan.countyId,
            startDate: scan.startDate,
            page: index + 2,
            stubCount: null,
          })),
        })

        await tx.scan.update({
          where: { id: scan.id },
          data: { chunkCount: { increment: projectChunkResult.count } },
        })
      }
    })
  } catch (e) {
    const error = await prisma.error.create({
      data: {
        status: ErrorStatus.BLOCKING,
        code: (e as any).code,
        message: (e as any).message,
        stack: (e as any).stack,
      },
    })
    await prisma.tick.update({
      where: { id: tick.id },
      data: { errorId: error.id },
    })
  }

  return tick
}
