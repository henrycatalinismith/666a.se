import slugify from 'slugify'

import { Municipality, db } from '../lib/database'

export async function lookupMunicipality(m: string): Promise<Municipality> {
  const matches = m.match(/(\d{4})/)
  if (!matches) {
    throw new Error(`No municipality ID found in "${m}"`)
  }
  const code = matches[1]
  const municipality = await db
    .selectFrom('municipality')
    .selectAll()
    .where('code', '=', code)
    .executeTakeFirst()
  if (!municipality) {
    throw new Error(`No municipality found for ID "${code}"`)
  }
  return municipality as any as Municipality
}

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
    .where('county.slug', '=', slugify(county, { lower: true }))
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
