import { Company } from '@prisma/client'
import slugify from 'slugify'

import prisma from './database'
import { DiariumDocument } from './diarium'

export async function findOrCreateCompany(
  diariumDocument: DiariumDocument
): Promise<Company> {
  const company = await prisma.company.findFirst({
    where: { code: diariumDocument.companyCode },
  })
  if (company) {
    return company
  }
  const now = new Date()
  return await prisma.company.create({
    data: {
      created: now,
      updated: now,
      name: diariumDocument.companyName,
      code: diariumDocument.companyCode,
      slug: slugify(diariumDocument.companyName, { lower: true }),
    },
  })
}
