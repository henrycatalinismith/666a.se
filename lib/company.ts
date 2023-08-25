import slugify from 'slugify'

import { db } from '../lib/database'

export async function createCompany({
  name,
  code,
}: {
  name: string
  code: string
}) {
  db.insertInto('company')
    .values({
      name,
      slug: slugify(name, {
        lower: true,
      }),
      code,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
}
