import { RoleName } from '@prisma/client'

import { NewSubscription } from 'forms/NewSubscription'
import { requireUser } from 'lib/authentication'

export default async function NewSubscriptionPage() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <h1>New Subscription</h1>
        <div className="bg-snow flex justify-start items-center">
          <NewSubscription />
        </div>
      </div>
    </>
  )
}
