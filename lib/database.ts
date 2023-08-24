import 'server-only'
import { Kysely } from 'kysely'
import { PlanetScaleDialect } from 'kysely-planetscale'

// interface User {
//   id: Generated<number>
//   name: string
//   username: string
//   email: string
// }

export interface Database {
  // users: User
}

export const db = new Kysely<Database>({
  dialect: new PlanetScaleDialect({
    url: process.env.DATABASE_URL,
  }),
})
