import { County, Scan } from '@prisma/client'

import { findNewestArtefactDate } from './county'
import prisma from './database'

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
