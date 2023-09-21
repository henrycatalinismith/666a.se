import { RoleName } from '@prisma/client'

import { IconDefinitionList, IconDefinitionListDefinition, IconDefinitionListIcon, IconDefinitionListItem, IconDefinitionListRow, IconDefinitionListTerm } from 'components/IconDefinitionList'
import { NotificationIconDefinition } from 'entities/Notification'
import { RefreshIconDefinition } from 'entities/Refresh'
import { SubscriptionIconDefinition } from 'entities/Subscription'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import Link from 'next/link'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Refresh({ params }: any) {
  const currentUser = await requireUser([RoleName.DEVELOPER])
  if (!currentUser) {
    return <></>
  }

  const refresh = await prisma.refresh.findFirstOrThrow({
    where: { id: params.id },
    include: { notifications: true, subscription: true },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={RefreshIconDefinition}
          title="Refresh"
          subtitle={`${refresh.id}`}
        />

        <IconDefinitionList>
          <IconDefinitionListRow>
            <IconDefinitionListIcon icon={SubscriptionIconDefinition} />
            <IconDefinitionListItem>
              <IconDefinitionListTerm>Subscription</IconDefinitionListTerm>
              <IconDefinitionListDefinition>
                <Link href={`/admin/subscriptions/${refresh.subscription.id}`}>
                  {refresh.subscription.id}
                </Link>
              </IconDefinitionListDefinition>
            </IconDefinitionListItem>
          </IconDefinitionListRow>
        </IconDefinitionList>

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
