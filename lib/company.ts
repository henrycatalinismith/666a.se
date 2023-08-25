import _ from 'lodash'
import slugify from 'slugify'

import { Company, db } from '../lib/database'

export async function fetchAllCompanies(): Promise<Company[]> {
  const companies = await db.selectFrom('company').selectAll().execute()
  return companies as any as Company[]
}

export async function fetchAllCompanyCodes(): Promise<string[]> {
  const codes = await db.selectFrom('company').select('code').execute()
  return _.map(codes, 'code')
}

export async function lookupCompanyById({
  id,
}: {
  id: number
}): Promise<Company> {
  const company = await db
    .selectFrom('company')
    .selectAll()
    .where('id', '=', id)
    .executeTakeFirst()
  return company as any as Company
}

export async function lookupCompanyByCode({
  code,
}: {
  code: string
}): Promise<Company> {
  const company = await db
    .selectFrom('company')
    .selectAll()
    .where('code', '=', code)
    .executeTakeFirst()
  if (!code) {
    throw new Error(`No company found for ID "${code}"`)
  }
  return company as any as Company
}

export async function createCompany({
  name,
  code,
}: {
  name: string
  code: string
}) {
  await db
    .insertInto('company')
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
