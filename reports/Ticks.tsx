import { faFileLines } from '@fortawesome/free-solid-svg-icons'
import { ErrorStatus, TickType } from '@prisma/client'
import { Error } from 'components/Error'
import { IconLink } from 'components/IconLink'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from 'components/Table'
import prisma from 'lib/database'
import _ from 'lodash'

export default async function Ingestion() {
  const blockingError = await prisma.error.findFirst({
    where: { status: ErrorStatus.BLOCKING },
  })

  const ticks = await prisma.tick.findMany({
    orderBy: { created: 'desc' },
    include: { scan: true, chunk: true, stub: true },
    take: 32,
  })

  const counties = _.keyBy(
    await prisma.county.findMany({
      where: {
        id: {
          in: _.chain(ticks)
            .filter({ type: TickType.SCAN })
            .map('scan.countyId')
            .value(),
        },
      },
    }),
    'id'
  )

  return (
    <>
      {blockingError && <Error error={blockingError} />}
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="text-left">Date</TableHead>
            <TableHead className="text-left">Status</TableHead>
            <TableHead className="text-left">Type</TableHead>
            <TableHead className="text-left">Summary</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {ticks.map((tick) => (
            <TableRow key={tick.id}>
              <TableCell>
                {tick.created.toISOString().substring(0, 19).replace('T', ' ')}
              </TableCell>
              <TableCell>{tick.errorId ? 'ERROR' : 'OK'}</TableCell>
              <TableCell>{tick.type}</TableCell>
              <TableCell>
                {tick.type === TickType.SCAN && tick.scan && (
                  <>{counties[tick.scan?.countyId].name}</>
                )}
                {tick.type === TickType.CHUNK && <>{tick.chunk?.id}</>}
                {tick.type === TickType.STUB && (
                  <>
                    <IconLink
                      icon={faFileLines}
                      href={`/documents/${tick.stub?.documentCode}`}
                    >
                      {tick.stub?.documentCode as string}{' '}
                      {tick.stub?.caseName as string}
                    </IconLink>
                  </>
                )}
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </>
  )
}
