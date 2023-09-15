import { faHashtag } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { DayIconDefinition } from 'entities/Day'
import { ScanIconDefinition } from 'entities/Scan'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Day({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const day = await prisma.day.findFirstOrThrow({
    where: { date: new Date(params.date) },
    include: { scans: { orderBy: { created: 'asc' } } },
  })

  const documentCount = await prisma.document.count({
    where: { date: day.date },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-2">
        <IconHeading
          icon={DayIconDefinition}
          title="Day"
          subtitle={day.date.toISOString().substring(0, 10)}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faHashtag,
              text: 'Documents',
              subtitle: `${documentCount}`,
              show: true,
            },
          ]}
        />

        <LittleHeading>Scans</LittleHeading>

        <EntityList
          items={day.scans.map((s) => ({
            icon: ScanIconDefinition,
            href: `/admin/scans/${s.id}`,
            text: `${s.id}`,
            subtitle: s.status,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
