import { RoleName } from '@prisma/client'

import { NotificationIconDefinition } from 'entities/Notification'
import { SubscriptionIconDefinition } from 'entities/Subscription'
import { RefreshIconDefinition } from 'entities/Refresh'
import { UserIconDefinition } from 'entities/User'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'

export default async function Admin() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const notifications = await prisma.notification.count()
  const refreshes = await prisma.refresh.count()
  const subscriptions = await prisma.subscription.count()
  const users = await prisma.user.count()

  return (
    <>
      <div className="container flex flex-col gap-8 pt-8">
        <EntityList
          items={[
            {
              icon: NotificationIconDefinition,
              text: 'Notifications',
              subtitle: `${notifications}`,
              href: '/admin/notifications',
              show: true,
            },

            {
              icon: RefreshIconDefinition,
              text: 'Refreshes',
              subtitle: `${refreshes}`,
              href: '/admin/refreshes',
              show: true,
            },

            {
              icon: SubscriptionIconDefinition,
              text: 'Subscriptions',
              subtitle: `${subscriptions}`,
              href: '/admin/subscriptions',
              show: true,
            },

            {
              icon: UserIconDefinition,
              text: 'Users',
              subtitle: `${users}`,
              href: '/admin/users',
              show: true,
            },

          ]}
        />
      </div>
    </>
  )
}
