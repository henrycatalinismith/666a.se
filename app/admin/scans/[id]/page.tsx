import { faHashtag, faPercent } from '@fortawesome/free-solid-svg-icons'
import { ChunkStatus, RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'entities/Chunk'
import { DayIconDefinition } from 'entities/Day'
import { ScanIconDefinition } from 'entities/Scan'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { LittleHeading } from 'ui/LittleHeading'

export default async function Scan({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const scan = await prisma.scan.findFirstOrThrow({
    where: { id: params.id },
    include: {
      day: true,
      chunks: { orderBy: { page: 'asc' } },
    },
  })

  const documentCount = await prisma.document.count({
    where: { date: scan.day.date },
  })

  const stubCount = await prisma.stub.count({
    where: { chunkId: { in: _.map(scan.chunks, 'id') } },
  })

  return (
    <>
      <div className="container flex flex-col pt-8 gap-2">
        <IconHeading
          icon={ScanIconDefinition}
          title="Scan"
          subtitle={scan.id}
        />

        <Relations
          rows={[
            {
              icon: DayIconDefinition,
              text: 'Day',
              subtitle: `${scan.day.date.toISOString().substring(0, 10)}`,
              href: `/admin/days/${scan.day.date
                .toISOString()
                .substring(0, 10)}`,
              show: true,
            },

            {
              type: 'text',
              icon: faHashtag,
              text: 'Documents',
              subtitle: `${documentCount}`,
              show: true,
            },

            {
              type: 'text',
              icon: faHashtag,
              text: 'Stubs',
              subtitle: `${stubCount}`,
              show: true,
            },

            {
              type: 'text',
              icon: faPercent,
              text: 'Progress',
              subtitle: `${Math.ceil(
                (_.filter(scan.chunks, { status: ChunkStatus.SUCCESS }).length /
                  scan.chunks.length) *
                  100
              )}%`,
              show: true,
            },
          ]}
        />

        <LittleHeading>Chunks</LittleHeading>

        <EntityList
          items={scan.chunks.map((c) => ({
            icon: ChunkIconDefinition,
            href: `/admin/chunks/${c.id}`,
            text: `${c.id}`,
            subtitle: c.status,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
