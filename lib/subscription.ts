import { Subscription, User, db } from '../lib/database'

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

export async function fetchAllSubscriptions(): Promise<Subscription[]> {
  const subscriptions = await db
    .selectFrom('subscription')
    .selectAll()
    .execute()
  return subscriptions as any as Subscription[]
}

export async function fetchSubscribedCompanyCodes(): Promise<string[]> {
  const result = await db
    .selectFrom('subscription')
    .leftJoin('company', 'company.id', 'subscription.target_id')
    .select('company.code')
    .distinct()
    .execute()
  const codes = result.map((r) => r.code!)
  return codes
}

export async function findSubscribersByCompanyId({
  company_id,
}: {
  company_id: number
}): Promise<User[]> {
  const result = await db
    .selectFrom('subscription')
    .leftJoin('user', 'user.id', 'subscription.user_id')
    .selectAll('user')
    .where('target_type', '=', 'company')
    .where('target_id', '=', company_id)
    .execute()
  const users = result.map((r) => r as any as User)
  return users
}
