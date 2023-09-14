import { RoleName } from '@prisma/client'
import { CountyIconDefinition } from 'entities/County'
import { DayIconDefinition } from 'entities/Day'
import { MunicipalityIconDefinition } from 'entities/Municipality'
import { TypeIconDefinition } from 'entities/Type'
import { UserIconDefinition } from 'entities/User'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'

export default async function Admin() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const counties = await prisma.county.count()
  const days = await prisma.day.count()
  const municipalities = await prisma.municipality.count()
  const types = await prisma.type.count()
  const users = await prisma.user.count()

  return (
    <>
      <div className="container flex flex-col gap-8 pt-8">
        <EntityList
          items={[
            {
              icon: CountyIconDefinition,
              text: 'Counties',
              subtitle: `${counties}`,
              href: '/admin/counties',
              show: true,
            },

            {
              icon: DayIconDefinition,
              text: 'Days',
              subtitle: `${days}`,
              href: '/admin/days',
              show: true,
            },

            {
              icon: MunicipalityIconDefinition,
              text: 'Municipalities',
              subtitle: `${municipalities}`,
              href: '/admin/municipalities',
              show: true,
            },

            {
              icon: TypeIconDefinition,
              text: 'Types',
              subtitle: `${types}`,
              href: '/admin/types',
              show: true,
            },

            {
              icon: UserIconDefinition,
              text: 'Users',
              subtitle: `${users}`,
              href: '/admin/users',
              show: true,
            },
          ]}
        />
      </div>
    </>
  )
}
