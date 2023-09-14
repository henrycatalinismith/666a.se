import { RoleName } from '@prisma/client'
import { UserIconDefinition } from 'entities/User'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'

export default async function User({ params }: any) {
  const currentUser = await requireUser([RoleName.DEVELOPER])
  if (!currentUser) {
    return <></>
  }

  const user = await prisma.user.findFirstOrThrow({
    where: { id: params.id },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={UserIconDefinition}
          title="User"
          subtitle={`${user.id}`}
        />
      </div>
    </>
  )
}
