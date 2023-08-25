import slugify from 'slugify'

import { db } from '../lib/database'

export async function createMunicipality({
  name,
  code,
  county,
}: {
  name: string
  code: string
  county: string
}) {
  const result = await db
    .selectFrom('county')
    .select('id')
    .where('county.slug', '=', slugify(county))
    .executeTakeFirst()

  if (!result) {
    console.log(county)
    return
  }

  const slug = name === 'Håbo' ? 'haabo' : slugify(name, { lower: true })

  await db
    .insertInto('municipality')
    .values({
      county_id: result.id,
      name,
      slug,
      code,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
  console.log(`${code}: ${name}`)
}
