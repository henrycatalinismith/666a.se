import bcrypt from 'bcrypt'

import { db } from '../lib/database'

export async function createUser({
  name,
  email,
  password,
}: {
  name: string
  email: string
  password: string
}) {
  console.log({ name, email, password })

  const existing = await db
    .selectFrom('user')
    .select('id')
    .where('email', '=', email)
    .execute()
  if (existing.length > 0) {
    throw new Error(`Email address ${email} already in use`)
  }

  const hash = await bcrypt.hash(password, 10)
  await db
    .insertInto('user')
    .values({
      name,
      email,
      password: hash,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
}

export async function validLogin({
  email,
  password,
}: {
  email: string
  password: string
}): Promise<boolean> {
  const user = await db
    .selectFrom('user')
    .selectAll()
    .where('email', '=', email)
    .executeTakeFirst()
  if (!user) {
    return false
  }
  const passwordMatches = await bcrypt.compare(password, user.password)
  return passwordMatches
}
