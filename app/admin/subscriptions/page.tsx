import { RoleName } from '@prisma/client'

import { SubscriptionIconDefinition } from 'entities/Subscription'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Subscriptions() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const subscriptions = await prisma.subscription.findMany({
    orderBy: {
      created: 'desc',
    },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={SubscriptionIconDefinition}
          title="Subscriptions"
          subtitle={`${subscriptions.length}`}
          newUrl="/admin/subscriptions/new"
        />

        <EntityList
          items={subscriptions.map((subscription) => ({
            icon: SubscriptionIconDefinition,
            href: `/admin/subscriptions/${subscription.id}`,
            subtitle: subscription.userId,
            text: subscription.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
