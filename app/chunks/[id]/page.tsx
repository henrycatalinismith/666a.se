import { faCube, faCubes, faFileLines } from '@fortawesome/free-solid-svg-icons'

import { IconHeading } from '../../../components/IconHeading'
import { IconLink } from '../../../components/IconLink'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../../components/Table'
import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export default async function Document({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id: params.id },
    include: { stubs: { include: { document: true } } },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <div className="space-y-3">
          <IconHeading icon={faCubes}>{chunk.id}</IconHeading>
          <p className="text-lg text-muted-foreground">
            {chunk.created.toISOString().substring(0, 19).replace('T', ' ')}
          </p>
        </div>

        <h2 className="font-heading scroll-m-20 text-xl font-semibold tracking-tight">
          Stubs
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-left">Code</TableHead>
              <TableHead className="text-left">Document</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {chunk.stubs.map((stub) => (
              <TableRow key={stub.id}>
                <TableCell>
                  <IconLink icon={faCube} href={`/stubs/${stub.id}`}>
                    {stub.id}
                  </IconLink>
                </TableCell>
                <TableCell>
                  {stub.document && (
                    <IconLink
                      icon={faFileLines}
                      href={`/documents/${stub.document.code}`}
                    >
                      {stub.document.code}
                    </IconLink>
                  )}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
