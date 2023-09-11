import { faCalendar, faClock } from '@fortawesome/free-solid-svg-icons'
import { Relations } from 'components/Relations'
import { CountyIconDefinition } from 'entities/County'
import { ScanIconDefinition } from 'entities/Scan'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
import { Card } from 'ui/Card'
import { IconHeading } from 'ui/IconHeading'
import { Progress } from 'ui/Progress'

export default async function Document({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const scan = await prisma.scan.findFirstOrThrow({
    where: { id: params.id },
    include: {
      county: true,
      chunks: { include: { county: true }, orderBy: { page: 'asc' } },
    },
  })

  const totalChunks = scan.chunks.length
  const completeChunks = _.filter(scan.chunks, { status: 'SUCCESS' }).length
  const progress = (completeChunks / totalChunks) * 100

  const tickCount = await prisma.tick.count({ where: { scanId: scan.id } })

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
              text: 'Start date',
              subtitle: scan.startDate
                ?.toISOString()
                .substring(0, 10) as string,
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
              icon: CountyIconDefinition,
              href: `/counties/${scan.county.slug}`,
              text: 'County',
              subtitle: scan.county.name,
              show: true,
            },
          ]}
        />

        {scan.status === 'ONGOING' && (
          <Card className="p-8 mt-8 mb-8">
            <Progress value={progress} />
          </Card>
        )}
      </div>
    </>
  )
}
