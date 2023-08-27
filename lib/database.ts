import { Generated, Kysely } from 'kysely'
import { PlanetScaleDialect } from 'kysely-planetscale'

export interface Company {
  id: Generated<number>
  code: string
  name: string
  slug: string
  created: Date
  updated: Date
}

export interface County {
  id: Generated<number>
  code: string
  name: string
  slug: string
  created: Date
  updated: Date
}

export interface Municipality {
  id: Generated<number>
  county_id: number
  code: string
  name: string
  slug: string
  created: Date
  updated: Date
}

export interface Document {
  id: Generated<number>
  case_id: number
  company_id: number
  county_id: number
  municipality_id: number
  code: string
  type: string
  cfar: string
  workplace: string
  direction: 'incoming' | 'outgoing' | 'blank'
  status: 'ongoing' | 'complete'
  filed: Date
  created: Date
  updated: Date
}

export interface Case {
  id: Generated<number>
  company_id: number
  code: string
  name: string
  created: Date
  updated: Date
}

export interface User {
  id: Generated<number>
  name: string
  email: string
  password: string
  created: Date
  updated: Date
}

export interface Session {
  id: Generated<number>
  user_id: number
  secret: string
  created: Date
  updated: Date
}

export interface Subscription {
  id: Generated<number>
  user_id: number
  target_type: string
  target_id: number
  created: Date
  updated: Date
}

export interface Database {
  case: Case
  company: Company
  county: County
  municipality: Municipality
  document: Document
  user: User
  session: Session
  subscription: Subscription
}

export const db = new Kysely<Database>({
  dialect: new PlanetScaleDialect({
    url: process.env.DATABASE_URL,
  }),
})
