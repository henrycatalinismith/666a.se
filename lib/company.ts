import slugify from 'slugify'

import { db } from '../lib/database'

export async function createCompany({
  name,
  number,
}: {
  name: string
  number: string
}) {
  db.insertInto('company')
    .values({
      name,
      slug: slugify(name, {
        lower: true,
      }),
      number,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
}
