import { RoleName } from '@prisma/client'
import { CountyIconDefinition } from 'entities/County'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Counties() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const counties = await prisma.county.findMany({
    orderBy: { name: 'asc' },
  })

  const total = await prisma.county.count()

  return (
    <>
      <div className="container flex flex-col gap-8 py-8">
        <IconHeading
          icon={CountyIconDefinition}
          title="Counties"
          subtitle={`${total}`}
        />
        <EntityList
          items={counties.map((county) => ({
            icon: CountyIconDefinition,
            href: `/admin/counties/${county.slug}`,
            text: county.name,
            subtitle: county.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
