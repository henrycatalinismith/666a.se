import { RoleName, SearchStatus } from '@prisma/client'

import { Relations } from 'components/Relations'
import { NotificationIconDefinition } from 'entities/Notification'
import { RefreshIconDefinition } from 'entities/Refresh'
import { SearchIconDefinition } from 'entities/Search'
import { SubscriptionIconDefinition } from 'entities/Subscription'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Refresh({ params }: any) {
  const currentUser = await requireUser([RoleName.Developer])
  if (!currentUser) {
    return <></>
  }

  const refresh = await prisma.refresh.findFirstOrThrow({
    where: { id: params.id },
    include: { notifications: true, search: true, subscription: true },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={RefreshIconDefinition}
          title="Refresh"
          subtitle={`${refresh.id}`}
        />

        <Relations
          rows={[
            {
              icon: SubscriptionIconDefinition,
              type: 'link',
              text: 'Subscription',
              subtitle: refresh.subscription.companyCode,
              href: `/admin/subscriptions/${refresh.subscription.id}`,
              show: true,
            },
            {
              icon: SearchIconDefinition,
              type: 'link',
              text: 'Search',
              subtitle:
                refresh.search.status === SearchStatus.Success
                  ? refresh.search.hitCount!
                  : refresh.search.status,
              href: `/admin/searches/${refresh.search.id}`,
              show: true,
            },
          ]}
        />

        <LittleHeading>Notifications</LittleHeading>

        <EntityList
          items={refresh.notifications.map((notification) => ({
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
