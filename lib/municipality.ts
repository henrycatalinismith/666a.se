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
