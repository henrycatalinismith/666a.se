import { v4 as uuid } from 'uuid'

import { Session, db } from '../lib/database'

export async function createSession({
  user_id,
}: {
  user_id: number
}): Promise<Session> {
  const secret = uuid()
  const [result] = await db
    .insertInto('session')
    .values({
      user_id,
      secret,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
  const session = await findSessionById({
    id: result.insertId as any as number,
  })
  return session as any as Session
}

export async function findSessionById({
  id,
}: {
  id: number
}): Promise<Session | undefined> {
  const session = await db
    .selectFrom('session')
    .selectAll()
    .where('id', '=', id)
    .executeTakeFirst()
  if (!session) {
    return undefined
  }
  return session as any as Session
}

export async function findSessionBySecret({
  secret,
}: {
  secret: string
}): Promise<Session | undefined> {
  const session = await db
    .selectFrom('session')
    .selectAll()
    .where('secret', '=', secret)
    .executeTakeFirst()
  if (!session) {
    return undefined
  }
  return session as any as Session
}
