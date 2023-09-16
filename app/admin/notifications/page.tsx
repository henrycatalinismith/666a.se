import { RoleName } from '@prisma/client'
import { NotificationIconDefinition } from 'entities/Notification'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Notifications() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const notifications = await prisma.notification.findMany({
    orderBy: {
      created: 'desc',
    },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={NotificationIconDefinition}
          title="Notifications"
          subtitle={`${notifications.length}`}
        />

        <EntityList
          items={notifications.map((notification) => ({
            icon: NotificationIconDefinition,
            href: `/admin/notifications/${notification.id}`,
            subtitle: notification.userId,
            text: notification.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
