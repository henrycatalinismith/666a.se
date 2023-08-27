import _ from 'lodash'

import { Document, db } from '../lib/database'

import { createCase, lookupCaseByCode } from './case'
import { lookupCompanyByCode } from './company'
import { lookupMunicipality } from './municipality'
import { DocumentScrapeResult } from './scraper'

export async function importDocumentFromJson(document: {
  id: string
  topic: string
  type: string
  direction: 'Utgående' | 'Inkommande' | ''
  org: string
  cfar: string
  workplace: string
  county: string
  municipality: string
  date: string
  status: 'Avslutat' | 'Pågående'
}) {
  console.log(`${document.id}: ${document.topic}`)
  const company = await lookupCompanyByCode({ code: document.org })
  const municipality = await lookupMunicipality(document.municipality)
  const companyId = company.id as any as number
  const municipalityId = municipality.id as any as number
  const filed = new Date(Date.parse(document.date))

  const [caseCode] = document.id.match(/....\/....../)!
  let c = await lookupCaseByCode({ code: caseCode })
  if (!c) {
    c = await createCase({
      code: caseCode,
      name: document.topic,
      companyId: companyId,
    })
  }
  const caseId = c.id as any as number

  db.insertInto('document')
    .values({
      case_id: caseId,
      company_id: companyId,
      county_id: municipality.county_id,
      municipality_id: municipalityId,
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
      filed,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
}

export async function importScrapedDocument(
  scrapedDocument: DocumentScrapeResult
): Promise<Document> {
  const company = await lookupCompanyByCode({ code: scrapedDocument.company })
  const municipality = await lookupMunicipality(scrapedDocument.municipality)
  const companyId = company.id as any as number
  const municipalityId = municipality.id as any as number
  const filed = new Date(Date.parse(scrapedDocument.filed))

  const [caseCode] = scrapedDocument.code.match(/....\/....../)!
  let c = await lookupCaseByCode({ code: caseCode })
  if (!c) {
    c = await createCase({
      code: caseCode,
      name: scrapedDocument.topic,
      companyId: companyId,
    })
  }
  const caseId = c.id as any as number

  const [result] = await db
    .insertInto('document')
    .values({
      case_id: caseId,
      company_id: companyId,
      county_id: municipality.county_id,
      municipality_id: municipalityId,
      code: scrapedDocument.code,
      type: scrapedDocument.type,
      cfar: scrapedDocument.cfar,
      workplace: scrapedDocument.workplace,
      direction: {
        Utgående: 'outgoing',
        Inkommande: 'incoming',
        '': 'blank',
      }[scrapedDocument.direction] as 'outgoing' | 'incoming' | 'blank',
      status: {
        Avslutat: 'complete',
        Pågående: 'ongoing',
      }[scrapedDocument.status] as 'ongoing' | 'complete',
      filed,
      created: new Date(),
      updated: new Date(),
    })
    .execute()

  const document = await findDocumentById({
    id: result.insertId as any as number,
  })
  return document as any as Document
}

export async function findDocumentById({
  id,
}: {
  id: number
}): Promise<Document | undefined> {
  const document = await db
    .selectFrom('document')
    .selectAll()
    .where('id', '=', id)
    .executeTakeFirst()
  if (!document) {
    return undefined
  }
  return document as any as Document
}

export async function filterOutExistingDocumentCodes(
  codes: string[]
): Promise<string[]> {
  if (codes.length === 0) return []
  const matches = await db
    .selectFrom('document')
    .select('code')
    .where('code', 'in', codes)
    .execute()
  console.log({ codes, matches })
  return _.difference(codes, _.map(matches, 'code'))
}

export async function lookupDocumentsByCaseId({
  caseId,
}: {
  caseId: number
}): Promise<Document[]> {
  const documents = await db
    .selectFrom('document')
    .selectAll()
    .where('case_id', '=', caseId)
    .orderBy('filed')
    .orderBy('code')
    .execute()
  return documents as any as Document[]
}
