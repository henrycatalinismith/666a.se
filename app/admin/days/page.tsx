import { RoleName } from '@prisma/client'
import { DayIconDefinition } from 'entities/Day'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'

export default async function DaysIndex() {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const days = await prisma.day.findMany({
    orderBy: { date: 'desc' },
    take: 32,
  })

  const total = await prisma.day.count()

  return (
    <>
      <div className="container flex flex-col gap-8 py-8">
        <IconHeading
          icon={DayIconDefinition}
          title="Days"
          subtitle={`${total}`}
        />
        <EntityList
          items={days.map((day) => ({
            icon: DayIconDefinition,
            href: `/admin/days/${day.date.toISOString().substring(0, 10)}`,
            text: day.date.toISOString().substring(0, 10),
            subtitle: day.id,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
