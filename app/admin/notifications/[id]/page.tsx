import { faEnvelope } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'

import { Relations } from 'components/Relations'
import { SendButton } from 'components/SendButton'
import { NotificationIconDefinition } from 'entities/Notification'
import { RefreshIconDefinition } from 'entities/Refresh'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Notification({ params }: any) {
  const currentUser = await requireUser([RoleName.Developer])
  if (!currentUser) {
    return <></>
  }

  const notification = await prisma.notification.findFirstOrThrow({
    where: { id: params.id },
    include: { refresh: true },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={NotificationIconDefinition}
          title="Notification"
          subtitle={`${notification.id}`}
          actions={[<SendButton key="send" id={notification.id} />]}
        />

        <Relations
          rows={[
            {
              icon: RefreshIconDefinition,
              type: 'link',
              text: 'Refresh',
              subtitle: notification.refresh.id,
              href: `/admin/refreshes/${notification.refresh.id}`,
              show: true,
            },

            {
              icon: faEnvelope,
              type: 'text',
              text: 'Email Status',
              subtitle: notification.emailStatus,
              show: true,
            },
          ]}
        />
      </div>
    </>
  )
}
