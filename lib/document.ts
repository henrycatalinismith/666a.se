import { Document, Stub } from '@prisma/client'

import { findOrCreateCase } from './case'
import { findOrCreateCompany } from './company'
import prisma from './database'
import { DiariumDocument } from './diarium'
import { findOrCreateWorkplace } from './workplace'

export async function createDocument(
  diariumDocument: DiariumDocument
): Promise<Document> {
  const company = await findOrCreateCompany(diariumDocument)
  const _case = await findOrCreateCase(diariumDocument, company)
  const workplace = await findOrCreateWorkplace(diariumDocument)

  const county = await prisma.county.findFirstOrThrow({
    where: { code: diariumDocument.countyCode },
  })
  const municipality = await prisma.municipality.findFirstOrThrow({
    where: { code: diariumDocument.municipalityCode },
  })

  const type = await prisma.type.findFirstOrThrow({
    where: {
      name: diariumDocument.documentType,
    },
  })

  const d = await prisma.document.create({
    data: {
      caseId: _case.id,
      companyId: company.id,
      countyId: county.id,
      municipalityId: municipality.id,
      typeId: type.id,
      workplaceId: workplace.id,
      code: diariumDocument.documentCode,
      date: new Date(diariumDocument.documentDate),
      direction: diariumDocument.documentDirection,
      typeText: diariumDocument.documentType,
    },
  })

  return d
}
