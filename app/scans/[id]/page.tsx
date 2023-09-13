import { faBug, faCalendar, faClock } from '@fortawesome/free-solid-svg-icons'
import { RoleName } from '@prisma/client'
import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'entities/Chunk'
import { ScanIconDefinition } from 'entities/Scan'
import { StubIconDefinition } from 'entities/Stub'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
import { Card } from 'ui/Card'
import { EntityList } from 'ui/EntityList'
import { IconHeading } from 'ui/IconHeading'
import { Progress } from 'ui/Progress'

export default async function Document({ params }: any) {
  const user = await requireUser([RoleName.DEVELOPER])
  if (!user) {
    return <></>
  }

  const scan = await prisma.scan.findFirstOrThrow({
    where: { id: params.id },
    include: {
      chunks: { orderBy: { page: 'asc' } },
    },
  })

  const totalChunks = scan.chunks.length
  const completeChunks = _.filter(scan.chunks, { status: 'SUCCESS' }).length
  const progress = (completeChunks / totalChunks) * 100

  const tickCount = await prisma.tick.count({ where: { scanId: scan.id } })
  const errorCount = await prisma.tick.count({
    where: { scanId: scan.id, errorId: { not: null } },
  })

  const latestTicks = await prisma.tick.findMany({
    where: { scanId: scan.id },
    include: { chunk: true, stub: true },
    orderBy: { created: 'desc' },
    take: 32,
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <IconHeading
          icon={ScanIconDefinition}
          title={`Scan`}
          subtitle={scan.id}
        />

        <Relations
          rows={[
            {
              type: 'text',
              icon: faCalendar,
              text: 'Date',
              subtitle: scan.date?.toISOString().substring(0, 10) as string,
              show: true,
            },

            {
              type: 'text',
              icon: faClock,
              text: 'Ticks',
              subtitle: `${tickCount}`,
              show: true,
            },

            {
              type: 'text',
              icon: faBug,
              text: 'Errors',
              subtitle: `${errorCount}`,
              show: true,
            },
          ]}
        />

        {scan.status === 'ONGOING' && (
          <Card className="p-8 mt-8 mb-8">
            <Progress value={progress} />
          </Card>
        )}

        <EntityList
          items={latestTicks
            .filter((tick) => !!tick.chunk || !!tick.stub)
            .map((tick) => {
              if (tick.stub) {
                return {
                  icon: StubIconDefinition,
                  href: `/stubs/${tick.stub.id}`,
                  text: tick.stub.documentType,
                  subtitle: tick.stub.documentCode,
                  show: true,
                }
              }
              return {
                icon: ChunkIconDefinition,
                href: `/chunks/${tick.chunk!.id}`,
                text: `${tick.chunk!.page}`,
                subtitle: tick.chunk!.id,
                show: true,
              }
            })}
        />
      </div>
    </>
  )
}
