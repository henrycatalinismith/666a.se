import { Notification, db } from '../lib/database'

export async function createNotification({
  user_id,
  target_type,
  target_id,
  type,
}: {
  user_id: number
  target_type: string
  target_id: number
  type: string
}) {
  const [result] = await db
    .insertInto('notification')
    .values({
      user_id,
      target_type,
      target_id,
      type,
      created: new Date(),
      updated: new Date(),
    })
    .returning('id')
    .execute()

  const notification = await findNotificationById({
    id: result.id as any as number,
  })
  return notification as any as Notification
}

export async function findNotificationById({
  id,
}: {
  id: number
}): Promise<Notification | undefined> {
  const notification = await db
    .selectFrom('notification')
    .selectAll()
    .where('id', '=', id)
    .executeTakeFirst()
  if (!notification) {
    return undefined
  }
  return notification as any as Notification
}

export async function findNewNotificationsByUserId({
  user_id,
}: {
  user_id: number
}): Promise<Notification[]> {
  const notifications = await db
    .selectFrom('notification')
    .selectAll()
    .where('user_id', '=', user_id)
    .where('seen', 'is', null)
    .execute()
  return notifications as any as Notification[]
}
