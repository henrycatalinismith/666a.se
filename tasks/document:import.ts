import { PrismaClient } from '@prisma/client'
import _ from 'lodash'

import documents from '../data/document.json'
const prisma = new PrismaClient()
;(async () => {
  for (const document of documents) {
    const company = await prisma.company.findFirstOrThrow({
      where: {
        code: document.org,
      },
    })
    const municipality = await prisma.municipality.findFirstOrThrow({
      where: {
        code: document.municipality.match(/(\d{4})/)![1],
      },
    })
    const [caseCode] = document.id.match(/....\/....../)!
    const existingCase = await prisma.case.findFirst({
      where: {
        code: caseCode,
      },
    })
    const caseId =
      existingCase?.id ??
      (
        await prisma.case.create({
          data: {
            code: caseCode,
            name: document.topic,
            companyId: company.id,
          },
        })
      ).id

    await prisma.document.create({
      data: {
        caseId: caseId,
        companyId: company.id,
        countyId: municipality.countyId,
        municipalityId: municipality.id,
        code: document.id,
        type: document.type,
        cfar: document.cfar,
        workplace: document.workplace,
        direction: {
          Utgående: 'outgoing',
          Inkommande: 'incoming',
          '': 'blank',
        }[document.direction] as 'outgoing' | 'incoming' | 'blank',
        status: {
          Avslutat: 'complete',
          Pågående: 'ongoing',
        }[document.status] as 'ongoing' | 'complete',
        filed: new Date(Date.parse(document.date)),
        created: new Date(),
        updated: new Date(),
      },
    })
  }
})()
