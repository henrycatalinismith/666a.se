import { faCubes, faSatelliteDish } from '@fortawesome/free-solid-svg-icons'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { IconHeading } from 'ui/IconHeading'
import { IconLink } from 'ui/IconLink'
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

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={faSatelliteDish}
          title={`${scan.county.name} ${scan.startDate
            ?.toISOString()
            .substring(0, 10)}`}
          subtitle={scan.id}
        />

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
                  <IconLink icon={faCubes} href={`/chunks/${chunk.id}`}>
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
