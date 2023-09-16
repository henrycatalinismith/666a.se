import { RoleName } from '@prisma/client'
import { UserIconDefinition } from 'entities/User'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { Button } from 'ui/Button'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Users() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const users = await prisma.user.findMany({
    orderBy: {
      created: 'asc',
    },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={UserIconDefinition}
          title="Users"
          subtitle={`${users.length}`}
          newUrl="/admin/users/new"
        />

        <EntityList
          items={users.map((user) => ({
            icon: UserIconDefinition,
            href: `/admin/users/${user.id}`,
            subtitle: user.email,
            text: user.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
