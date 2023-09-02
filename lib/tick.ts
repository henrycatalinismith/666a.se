import { Tick } from '@prisma/client'

import prisma from './database'
import { ingestChunk, ingestStub } from './ingestion'
import { scanCounty } from './scan'

export async function createTick(): Promise<Tick> {
  console.log('creating tick')

  const stub = await prisma.stub.findFirst({
    where: { ingested: null },
    orderBy: { created: 'asc' },
  })

  const chunk = await prisma.chunk.findFirst({
    where: { ingested: null },
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
  const now = new Date()
  const tick = await prisma.tick.create({
    data: {
      created: now,
      updated: now,
      targetType: 'stub',
      targetId: stubId,
    },
  })

  await ingestStub(stubId)

  return tick
}

async function tickChunk(chunkId: string): Promise<Tick> {
  const now = new Date()
  const tick = await prisma.tick.create({
    data: {
      created: now,
      updated: now,
      targetType: 'chunk',
      targetId: chunkId,
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
      targetType: 'scan',
      targetId: scan.id,
    },
  })

  return tick
}
