import { Generated, Kysely } from 'kysely'
import { PlanetScaleDialect } from 'kysely-planetscale'

interface Company {
  id: Generated<number>
  code: string
  name: string
  slug: string
  created: Date
  updated: Date
}

interface County {
  id: Generated<number>
  code: string
  name: string
  slug: string
  created: Date
  updated: Date
}

interface Municipality {
  id: Generated<number>
  county_id: number
  code: string
  name: string
  slug: string
  created: Date
  updated: Date
}

interface Document {
  id: Generated<number>
  county_id: number
  municipality_id: number
  case_id: number
  code: string
  topic: string
  type: string
  created: Date
  updated: Date
}

export interface Database {
  company: Company
  county: County
  municipality: Municipality
}

export const db = new Kysely<Database>({
  dialect: new PlanetScaleDialect({
    url: process.env.DATABASE_URL,
  }),
})
