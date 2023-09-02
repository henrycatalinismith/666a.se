import { Case, Company } from '@prisma/client'

import prisma from './database'
import { DiariumDocument } from './diarium'

export async function findOrCreateCase(
  diariumDocument: DiariumDocument,
  company: Company
): Promise<Case> {
  const _case = await prisma.case.findFirst({
    where: { code: diariumDocument.caseCode },
  })
  if (_case) {
    return _case
  }

  const status = await prisma.status.findFirstOrThrow({
    where: { name: diariumDocument.caseStatus },
  })

  const now = new Date()
  return await prisma.case.create({
    data: {
      created: now,
      updated: now,
      companyId: company.id,
      statusId: status.id,
      name: diariumDocument.caseTopic,
      code: diariumDocument.caseCode,
    },
  })
}
