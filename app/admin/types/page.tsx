import { RoleName } from '@prisma/client'
import { TypeIconDefinition } from 'entities/Type'
import { UserIconDefinition } from 'entities/User'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Users() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const types = await prisma.type.findMany({
    orderBy: {
      name: 'asc',
    },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-8">
        <IconHeading
          icon={TypeIconDefinition}
          title="Types"
          subtitle={`${types.length}`}
        />

        <EntityList
          items={types.map((type) => ({
            icon: UserIconDefinition,
            href: `/admin/type/${type.slug}`,
            text: type.name,
            subtitle: type.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
