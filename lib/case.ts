import _ from 'lodash'

import { Case, db } from '../lib/database'

export async function fetchAllCaseCodes(): Promise<string[]> {
  const codes = await db.selectFrom('case').select('code').execute()
  return _.map(codes, 'code')
}

export async function lookupCasesByCompanyId({
  companyId,
}: {
  companyId: number
}): Promise<Case[]> {
  const cases = await db
    .selectFrom('case')
    .selectAll()
    .where('company_id', '=', companyId)
    .execute()
  return cases as any as Case[]
}

export async function lookupCaseByCode({
  code,
}: {
  code: string
}): Promise<Case | null> {
  const c = await db
    .selectFrom('case')
    .selectAll()
    .where('code', '=', code)
    .executeTakeFirst()
  if (!c) {
    return null
  }
  return c as any as Case
}

export async function createCase({
  code,
  name,
  companyId,
}: {
  code: string
  name: string
  companyId: number
}): Promise<Case> {
  await db
    .insertInto('case')
    .values({
      code,
      name,
      company_id: companyId,
      created: new Date(),
      updated: new Date(),
    })
    .execute()

  return lookupCaseByCode({ code }) as any as Case
}
