import { CaseStatus, Document } from '@prisma/client'
import slugify from 'slugify'

import { Transaction } from './database'
import { DiariumDocument } from './diarium'

export async function createDocument(
  diariumDocument: DiariumDocument,
  tx: Transaction
): Promise<Document> {
  let company = null
  let companyId = null
  if (diariumDocument.companyCode && diariumDocument.companyName) {
    company = await tx.company.findFirst({
      where: { code: diariumDocument.companyCode },
    })
    if (!company) {
      const now = new Date()
      const bareCompanyNameSlug = slugify(diariumDocument.companyName, {
        lower: true,
      })
      const extendedCompanySlug =
        bareCompanyNameSlug + diariumDocument.companyCode
      const slugCollision = await tx.company.findFirst({
        where: { slug: bareCompanyNameSlug },
      })
      const companySlug = slugCollision
        ? extendedCompanySlug
        : bareCompanyNameSlug

      company = await tx.company.create({
        data: {
          created: now,
          updated: now,
          name: diariumDocument.companyName,
          code: diariumDocument.companyCode,
          slug: companySlug,
        },
      })
    }
    companyId = company?.id
  }

  let caseId = null
  let _case = await tx.case.findFirst({
    where: { code: diariumDocument.caseCode },
  })
  const status =
    diariumDocument.caseStatus === 'Avslutat'
      ? CaseStatus.CONCLUDED
      : CaseStatus.ONGOING
  if (_case) {
    caseId = _case.id
  } else {
    const now = new Date()
    _case = await tx.case.create({
      data: {
        created: now,
        updated: now,
        companyId,
        status,
        name: diariumDocument.caseTopic,
        code: diariumDocument.caseCode,
      },
    })
    caseId = _case.id
  }
  console.log('case')
  console.log(_case)
  console.log(caseId)

  let workplaceId = null
  if (diariumDocument.workplaceCode && diariumDocument.workplaceName) {
    let workplace = await tx.workplace.findFirst({
      where: { code: diariumDocument.workplaceCode },
    })
    if (!workplace) {
      const now = new Date()
      workplace = await tx.workplace.create({
        data: {
          created: now,
          updated: now,
          name: diariumDocument.workplaceName,
          code: diariumDocument.workplaceCode,
        },
      })
      workplaceId = workplace.id
    }
  }

  const county = await tx.county.findFirstOrThrow({
    where: { code: diariumDocument.countyCode },
  })
  const municipality = await tx.municipality.findFirstOrThrow({
    where: { code: diariumDocument.municipalityCode },
  })

  const type = await tx.type.findFirstOrThrow({
    where: {
      name: diariumDocument.documentType,
    },
  })

  const d = await tx.document.create({
    data: {
      caseId: caseId!,
      companyId,
      countyId: county.id,
      municipalityId: municipality.id,
      typeId: type.id,
      workplaceId: workplaceId,
      code: diariumDocument.documentCode,
      date: new Date(diariumDocument.documentDate),
      direction: diariumDocument.documentDirection,
      typeText: diariumDocument.documentType,
    },
  })

  return d
}
