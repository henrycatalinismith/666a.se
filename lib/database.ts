import { Generated, Kysely } from 'kysely'
import { PlanetScaleDialect } from 'kysely-planetscale'

interface Company {
  id: Generated<number>
  name: string
  slug: string
  number: string
  created: Date
  updated: Date
}

interface County {
  id: Generated<number>
  name: string
  slug: string
  code: string
  created: Date
  updated: Date
}

interface Municipality {
  id: Generated<number>
  county_id: number
  name: string
  slug: string
  code: string
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
