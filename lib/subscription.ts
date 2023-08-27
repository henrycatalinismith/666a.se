import { Subscription, db } from '../lib/database'

export async function createSubscription({
  user_id,
  target_type,
  target_id,
}: {
  user_id: number
  target_type: string
  target_id: number
}) {
  const [result] = await db
    .insertInto('subscription')
    .values({
      user_id,
      target_type,
      target_id,
      created: new Date(),
      updated: new Date(),
    })
    .execute()
  const session = await findSubscriptionById({
    id: result.insertId as any as number,
  })
  return session as any as Subscription
}

export async function findSubscriptionById({
  id,
}: {
  id: number
}): Promise<Subscription | undefined> {
  const subscription = await db
    .selectFrom('subscription')
    .selectAll()
    .where('id', '=', id)
    .executeTakeFirst()
  if (!subscription) {
    return undefined
  }
  return subscription as any as Subscription
}
