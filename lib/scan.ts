import { County, Scan } from '@prisma/client'

import prisma from './database'

export async function findOngoingScan(county: County): Promise<Scan | null> {
  return await prisma.scan.findFirst({
    where: {
      countyId: county.id,
      completed: undefined,
    },
  })
}

export async function createScan(county: County): Promise<Scan> {
  const now = new Date()
  return await prisma.scan.create({
    data: {
      countyId: county.id,
      chunkCount: 1,
      completed: null,
      created: now,
      updated: now,
    },
  })
}
