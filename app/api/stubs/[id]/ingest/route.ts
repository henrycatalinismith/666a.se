import {
  CaseStatus,
  Document,
  RoleName,
  Stub,
  StubStatus,
} from '@prisma/client'
import { inngest } from 'inngest/client'
import { requireUser } from 'lib/authentication'
import prisma, { Transaction } from 'lib/database'
import { DiariumDocument, fetchDocument } from 'lib/diarium'
import { NextResponse } from 'next/server'
import slugify from 'slugify'

export async function POST(request: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return NextResponse.json({ status: 'failure' })
  }

  const id = request.url!.match(/stubs\/(.+)\//)![1]
  const stub = await prisma.stub.findFirstOrThrow({
    where: { id },
    include: { chunk: { include: { scan: { include: { day: true } } } } },
  })

  await prisma.$transaction(
    async (tx) => {
      const diariumDocument = await fetchDocument(stub.documentCode)
      const doc = await createDocument(diariumDocument, stub, tx)
      console.log(doc.id)

      await tx.stub.updateMany({
        data: { status: StubStatus.SUCCESS, documentId: doc.id },
        where: { documentCode: stub.documentCode },
      })

      const pendingSiblings = await tx.stub.count({
        where: {
          chunkId: stub.chunk.id,
          status: { in: [StubStatus.PENDING] },
        },
      })
      console.log({ pendingSiblings })
      if (pendingSiblings === 0) {
        await inngest.send({
          name: '666a/chunk.completed',
          data: {
            id: stub.chunkId,
          },
        })
      }
    },
    {
      timeout: 15000,
    }
  )

  return NextResponse.json([
    {
      status: 'success',
    },
  ])
}

export async function createDocument(
  diariumDocument: DiariumDocument,
  stub: Stub,
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
      date: stub.documentDate,
      direction: diariumDocument.documentDirection,
      typeText: diariumDocument.documentType,
    },
  })

  return d
}
