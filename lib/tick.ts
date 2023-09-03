import { ChunkStatus, StubStatus, Tick, TickType } from '@prisma/client'

import prisma from './database'
import { ingestChunk, ingestStub } from './ingestion'
import { scanCounty } from './scan'

export async function createTick(): Promise<Tick> {
  console.log('creating tick')

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

  await ingestStub(stubId)

  return tick
}

async function tickChunk(chunkId: string): Promise<Tick> {
  const chunk = await prisma.chunk.findFirstOrThrow({ where: { id: chunkId } })
  const now = new Date()
  const tick = await prisma.tick.create({
    data: {
      created: now,
      updated: now,
      scanId: chunk.scanId,
      chunkId: chunkId,
      type: TickType.CHUNK,
    },
  })
  await ingestChunk(chunkId)
  return tick
}

async function tickScan(countyId: string): Promise<Tick> {
  const scan = await scanCounty(countyId)

  await prisma.county.update({
    data: { ticked: new Date() },
    where: { id: countyId },
  })

  const now = new Date()
  const tick = await prisma.tick.create({
    data: {
      created: now,
      updated: now,
      scanId: scan.id,
      type: TickType.SCAN,
    },
  })

  return tick
}
