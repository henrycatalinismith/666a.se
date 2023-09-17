import { RoleName } from '@prisma/client'

import { CheckButton } from 'components/CheckButton'
import { CompanyCode } from 'components/CompanyCode'
import { DeleteButton } from 'components/DeleteButton'
import { IconDefinitionList } from 'components/IconDefinitionList'
import { SubscriptionIconDefinition } from 'entities/Subscription'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function Subscription({ params }: any) {
  const currentUser = await requireUser([RoleName.DEVELOPER])
  if (!currentUser) {
    return <></>
  }

  const subscription = await prisma.subscription.findFirstOrThrow({
    where: { id: params.id },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={SubscriptionIconDefinition}
          title="Subscription"
          subtitle={`${subscription.id}`}
          actions={[
            <DeleteButton
              key="delete"
              url={`/api/subscriptions/${subscription.id}`}
            />,
            <CheckButton key="check" id={subscription.id} />,
          ]}
        />

        <IconDefinitionList>
          <CompanyCode
            subscriptionId={subscription.id}
            companyCode={subscription.companyCode}
          />
        </IconDefinitionList>
      </div>
    </>
  )
}
