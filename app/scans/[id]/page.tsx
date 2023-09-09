import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'icons/ChunkIcon'
import { CountyIconDefinition } from 'icons/CountyIcon'
import { ScanIconDefinition } from 'icons/ScanIcon'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import _ from 'lodash'
import { Card } from 'ui/Card'
import { IconHeading } from 'ui/IconHeading'
import { IconLink } from 'ui/IconLink'
import { Progress } from 'ui/Progress'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from 'ui/Table'

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
  console.log(totalChunks)
  console.log(completeChunks)
  const progress = (completeChunks / totalChunks) * 100

  return (
    <>
      <div className="container pt-8 flex flex-col gap-2">
        <IconHeading
          icon={ScanIconDefinition}
          title={`${scan.county.name} ${scan.startDate
            ?.toISOString()
            .substring(0, 10)}`}
          subtitle={scan.id}
        />

        <Relations
          rows={[
            {
              icon: CountyIconDefinition,
              href: `/counties/${scan.county.slug}`,
              text: scan.county.name,
              show: true,
            },
          ]}
        />

        {scan.status === 'ONGOING' && (
          <Card className="p-8 mt-8 mb-8">
            <Progress value={progress} />
          </Card>
        )}

        <h2 className="font-heading scroll-m-20 text-xl font-semibold tracking-tight">
          Chunks
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-left">ID</TableHead>
              <TableHead className="text-left">Status</TableHead>
              <TableHead className="text-left">Hit Count</TableHead>
              <TableHead className="text-left">Stub Count</TableHead>
              <TableHead className="text-left">Updated</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {scan.chunks.map((chunk) => (
              <TableRow key={chunk.id}>
                <TableCell>
                  <IconLink
                    icon={ChunkIconDefinition}
                    href={`/chunks/${chunk.id}`}
                  >
                    {`${chunk.county.name} ${chunk.startDate
                      ?.toISOString()
                      .substring(0, 10)}`}
                  </IconLink>
                </TableCell>
                <TableCell>{chunk.status}</TableCell>
                <TableCell>{chunk.hitCount}</TableCell>
                <TableCell>{chunk.stubCount}</TableCell>
                <TableCell>
                  {chunk.updated
                    .toISOString()
                    .substring(0, 19)
                    .replace('T', ' ')}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
