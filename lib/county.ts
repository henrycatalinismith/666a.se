import { db } from '../lib/database'

export async function createCounty({
  name,
  code,
  slug,
}: {
  name: string
  code: string
  slug: string
}) {
  await db
    .insertInto('county')
    .values({
      name,
      code,
      slug,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
}
