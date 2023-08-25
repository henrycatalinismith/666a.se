import _ from 'lodash'

import { db } from '../lib/database'

import { createCase, loopupCaseByCode } from './case'
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
  const company = await lookupCompanyByCode(document.org)
  const municipality = await lookupMunicipality(document.municipality)
  const companyId = company.id as any as number
  const municipalityId = municipality.id as any as number
  const filed = new Date(Date.parse(document.date))

  const [caseCode] = document.id.match(/....\/....../)!
  let c = await loopupCaseByCode(caseCode)
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
  document: DocumentScrapeResult
): Promise<void> {
  const company = await lookupCompanyByCode(document.company)
  const municipality = await lookupMunicipality(document.municipality)
  const companyId = company.id as any as number
  const municipalityId = municipality.id as any as number
  const filed = new Date(Date.parse(document.filed))

  const [caseCode] = document.code.match(/....\/....../)!
  let c = await loopupCaseByCode(caseCode)
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
      code: document.code,
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

export async function filterOutExistingDocumentCodes(
  codes: string[]
): Promise<string[]> {
  if (codes.length === 0) return []
  const matches = await db
    .selectFrom('document')
    .select('code')
    .where('code', 'in', codes)
    .execute()
  return _.difference(codes, _.map(matches, 'code'))
}
