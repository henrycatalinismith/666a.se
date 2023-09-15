import {
  faGears,
  faHashtag,
  faPercent,
} from '@fortawesome/free-solid-svg-icons'
import { RoleName, StubStatus } from '@prisma/client'
import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'entities/Chunk'
import { DayIconDefinition } from 'entities/Day'
import { ScanIconDefinition } from 'entities/Scan'
import { StubIconDefinition } from 'entities/Stub'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Document({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id: params.id },
    include: {
      scan: {
        include: { day: true },
      },
      stubs: {
        include: { document: true },
        orderBy: { index: 'asc' },
      },
    },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={ChunkIconDefinition}
          title="Chunk"
          subtitle={chunk.id}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: ScanIconDefinition,
              text: 'Scan',
              subtitle: chunk.scan.id,
              show: true,
            },

            {
              type: 'text',
              icon: DayIconDefinition,
              text: 'Day',
              subtitle: chunk.scan.day.date.toISOString().substring(0, 10),
              show: true,
            },

            {
              type: 'text',
              icon: faHashtag,
              text: 'Page',
              subtitle: `${chunk.page}`,
              show: true,
            },

            {
              type: 'text',
              icon: faPercent,
              text: 'Progress',
              subtitle: `${Math.ceil(
                (_.filter(chunk.stubs, { status: StubStatus.SUCCESS }).length /
                  chunk.stubs.length) *
                  100
              )}%`,
              show: true,
            },

            {
              type: 'text',
              icon: faHashtag,
              text: 'Hit Count',
              subtitle: `${chunk.hitCount}`,
              show: true,
            },

            {
              type: 'text',
              icon: faGears,
              text: 'Status',
              subtitle: `${chunk.status}`,
              show: true,
            },
          ]}
        />

        <LittleHeading>Stubs</LittleHeading>

        <EntityList
          items={chunk.stubs.map((stub) => ({
            icon: StubIconDefinition,
            href: `/admin/stubs/${stub.id}`,
            text: stub.documentType,
            subtitle: `${stub.documentCode} ${stub.status}`,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
