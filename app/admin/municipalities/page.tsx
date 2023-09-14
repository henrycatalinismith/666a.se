import { RoleName } from '@prisma/client'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function Counties() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const municipalities = await prisma.municipality.findMany({
    orderBy: { name: 'asc' },
  })

  const total = await prisma.municipality.count()

  return (
    <>
      <div className="container flex flex-col gap-8 py-8">
        <IconHeading
          icon={MunicipalityIconDefinition}
          title="Municipalities"
          subtitle={`${total}`}
        />
        <EntityList
          items={municipalities.map((municipality) => ({
            icon: MunicipalityIconDefinition,
            href: `/admin/municipalities/${municipality.slug}`,
            text: municipality.name,
            subtitle: municipality.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
