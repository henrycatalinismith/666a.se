import { faHashtag, faPercent } from '@fortawesome/free-solid-svg-icons'
import { ChunkStatus, RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'entities/Chunk'
import { DayIconDefinition } from 'entities/Day'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
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
    include: { chunks: { orderBy: { page: 'asc' } } },
  })

  const documentCount = await prisma.document.count({
    where: { date: day.date },
  })

  const stubCount = await prisma.stub.count({
    where: { chunkId: { in: _.map(day.chunks, 'id') } },
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
                (_.filter(day.chunks, { status: ChunkStatus.SUCCESS }).length /
                  day.chunks.length) *
                  100
              )}%`,

              show: true,
            },
          ]}
        />

        <LittleHeading>Chunks</LittleHeading>

        <EntityList
          items={day.chunks.map((c) => ({
            icon: ChunkIconDefinition,
            href: `/admin/chunks/${c.id}`,
            text: `${c.page}`,
            subtitle: c.status,
            show: true,
          }))}
        />
      </div>
    </>
  )
}
