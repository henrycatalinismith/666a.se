import { Workplace } from '@prisma/client'

import prisma from './database'
import { DiariumDocument } from './diarium'

export async function findOrCreateWorkplace(
  diariumDocument: DiariumDocument
): Promise<Workplace> {
  const workplace = await prisma.workplace.findFirst({
    where: { code: diariumDocument.workplaceCode },
  })
  if (workplace) {
    return workplace
  }

  const now = new Date()
  return await prisma.workplace.create({
    data: {
      created: now,
      updated: now,
      name: diariumDocument.workplaceName,
      code: diariumDocument.workplaceCode,
    },
  })
}
