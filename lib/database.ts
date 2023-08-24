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

export interface Database {
  company: Company
}

export const db = new Kysely<Database>({
  dialect: new PlanetScaleDialect({
    url: process.env.DATABASE_URL,
  }),
})
