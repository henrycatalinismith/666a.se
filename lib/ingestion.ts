/*
import {
  CaseStatus,
  ChunkStatus,
  Document,
  ErrorStatus,
  StubStatus,
  Tick,
  TickType,
} from '@prisma/client'
import _ from 'lodash'
import * as puppeteer from 'puppeteer'
import slugify from 'slugify'

import { Transaction } from './database'
import prisma from './database'

async function launchBrowser(): Promise<puppeteer.Browser> {
  if (!(global as any).browser) {
    ;(global as any).browser = await puppeteer.launch({ headless: 'new' })
  }
  return (global as any).browser
}

export async function createTick(): Promise<Tick> {
  console.log('creating tick')
  const blockingError = await prisma.error.findFirst({
    where: { status: ErrorStatus.BLOCKING },
  })
  if (blockingError) {
    console.error(blockingError.id)
    console.error(blockingError.message)
    return await prisma.tick.findFirstOrThrow({
      where: { errorId: blockingError.id },
    })
  }

  const stub = await prisma.stub.findFirst({
    where: { status: StubStatus.PENDING },
    orderBy: { created: 'asc' },
  })

  const chunk = await prisma.chunk.findFirst({
    where: { status: { in: [ChunkStatus.PENDING, ChunkStatus.ONGOING] } },
    orderBy: { created: 'asc' },
  })

  let tick
  if (stub) {
    tick = await tickStub(stub.id)
  } else if (chunk) {
    tick = await tickChunk(chunk.id)
  } else {
    throw new Error('idk')
  }

  return tick
}

async function tickStub(stubId: string): Promise<Tick> {
  const stub = await prisma.stub.findFirstOrThrow({ where: { id: stubId } })
  const now = new Date()
  const tick = await prisma.tick.create({
    data: {
      created: now,
      updated: now,
      stubId: stubId,
      type: TickType.STUB,
    },
  })

  try {
    await prisma.$transaction(
      async (tx) => {
        await ingestStub(stubId, tx)
      },
      {
        timeout: 15000,
      }
    )
  } catch (e) {
    const error = await prisma.error.create({
      data: {
        status: ErrorStatus.BLOCKING,
        code: (e as any).code,
        message: (e as any).message,
        stack: (e as any).stack,
      },
    })
    await prisma.tick.update({
      where: { id: tick.id },
      data: { errorId: error.id },
    })
  }

  return tick
}

async function tickChunk(chunkId: string): Promise<Tick> {
  const tick = await prisma.tick.create({
    data: {
      chunkId: chunkId,
      type: TickType.CHUNK,
    },
  })

  try {
    await prisma.$transaction(
      async () => {
        // await ingestChunk(chunkId, tx)
      },
      {
        timeout: 15000,
      }
    )
  } catch (e) {
    const error = await prisma.error.create({
      data: {
        status: ErrorStatus.BLOCKING,
        code: (e as any).code,
        message: (e as any).message,
        stack: (e as any).stack,
      },
    })
  }

  return tick
}

async function ingestStub(stubId: string, tx: Transaction): Promise<void> {
  const stub = await tx.stub.findFirstOrThrow({
    where: { id: stubId, status: StubStatus.PENDING },
  })

  const diariumDocument = await fetchDocument(stub.documentCode)
  const doc = await createDocument(diariumDocument, tx)

  await tx.stub.update({
    data: { status: StubStatus.SUCCESS, documentId: doc.id },
    where: { id: stub.id },
  })

  const uningestedSiblings = await tx.stub.count({
    where: {
      chunkId: stub.chunkId,
      status: {
        in: [StubStatus.PENDING, StubStatus.ABORTED],
      },
    },
  })
  if (uningestedSiblings === 0) {
    await tx.chunk.update({
      where: { id: stub.chunkId },
      data: { status: ChunkStatus.SUCCESS, updated: new Date() },
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

*/
