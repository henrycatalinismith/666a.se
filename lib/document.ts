import { db } from '../lib/database'

import { lookupCompanyByCode } from './company'
import { lookupMunicipality } from './municipality'

export async function importDocument(document: {
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

  db.insertInto('document')
    .values({
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
      case_topic: document.topic,
    })
    .execute()
}
