import { CaseStatus, ChunkStatus, Document, StubStatus } from '@prisma/client'
import slugify from 'slugify'

import prisma, { Transaction } from '../lib/database'
import { DiariumDocument, fetchDocument } from '../lib/diarium'

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(() => resolve(), ms))
}

;(async () => {
  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { status: { in: [ChunkStatus.ONGOING] } },
    include: {
      stubs: {
        where: { status: { in: [StubStatus.PENDING] } },
        orderBy: { index: 'asc' },
      },
    },
    orderBy: { page: 'asc' },
  })
  const stubs = chunk.stubs

  for (const stub of stubs) {
    console.log(`${stub.id} ${stub.documentCode}`)
    console.log(chunk.id)

    await prisma.$transaction(
      async (tx) => {
        const d = await tx.document.findFirst({
          where: { code: stub.documentCode },
        })
        if (d) {
          console.log('oops')
          await tx.stub.updateMany({
            data: { status: StubStatus.SUCCESS, documentId: d.id },
            where: { documentCode: stub.documentCode },
          })
          await maybeChunkSuccess(tx, stub.chunkId)
          return
        }

        const diariumDocument = await fetchDocument(stub.documentCode)
        const doc = await createDocument(diariumDocument, tx)
        console.log(doc.id)

        await tx.stub.updateMany({
          data: { status: StubStatus.SUCCESS, documentId: doc.id },
          where: { documentCode: stub.documentCode },
        })

        await maybeChunkSuccess(tx, stub.chunkId)
      },
      {
        timeout: 15000,
      }
    )

    process.exit(0)
    await delay(3000)
  }

  process.exit(0)
})()

async function maybeChunkSuccess(
  tx: Transaction,
  chunkId: string
): Promise<void> {
  const pendingSiblings = await tx.stub.count({
    where: {
      chunkId,
      status: { in: [StubStatus.PENDING] },
    },
  })
  console.log({ pendingSiblings })
  if (pendingSiblings === 0) {
    await tx.chunk.update({
      where: { id: chunkId },
      data: { status: ChunkStatus.SUCCESS },
    })
  }
}

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

  const county = diariumDocument.countyCode
    ? await tx.county.findFirstOrThrow({
        where: { code: diariumDocument.countyCode },
      })
    : null
  const municipality = diariumDocument.municipalityCode
    ? await tx.municipality.findFirstOrThrow({
        where: { code: diariumDocument.municipalityCode },
      })
    : null

  const type = await tx.type.findFirstOrThrow({
    where: {
      name: diariumDocument.documentType,
    },
  })

  const d = await tx.document.create({
    data: {
      caseId: caseId!,
      companyId,
      countyId: county?.id,
      municipalityId: municipality?.id,
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
