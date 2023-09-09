import { Relations } from 'components/Relations'
import { ChunkIconDefinition } from 'icons/ChunkIcon'
import { CountyIconDefinition } from 'icons/CountyIcon'
import { DocumentIconDefinition } from 'icons/DocumentIcon'
import { ScanIconDefinition } from 'icons/ScanIcon'
import { StubIconDefinition } from 'icons/StubIcon'
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

  const chunk = await prisma.chunk.findFirstOrThrow({
    where: { id: params.id },
    include: {
      county: true,
      scan: { include: { county: true } },
      stubs: { include: { document: true } },
    },
  })

  return (
    <>
      <div className="container pt-8 flex flex-col gap-8">
        <IconHeading
          icon={ChunkIconDefinition}
          title={`${chunk.county.name} ${chunk.startDate
            ?.toISOString()
            .substring(0, 10)}`}
          subtitle={chunk.id}
        />

        <Relations
          rows={[
            {
              icon: ScanIconDefinition,
              href: `/scans/${chunk.scan.id}`,
              text: `${chunk.scan.county.name} ${chunk.scan.startDate
                ?.toISOString()
                .substring(0, 10)}`,
              show: true,
            },

            {
              icon: CountyIconDefinition,
              href: `/counties/${chunk.county.slug}`,
              text: chunk.county.name,
              show: true,
            },
          ]}
        />

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
                  <IconLink
                    icon={StubIconDefinition}
                    href={`/stubs/${stub.id}`}
                  >
                    {stub.id}
                  </IconLink>
                </TableCell>
                <TableCell>
                  {stub.document && (
                    <IconLink
                      icon={DocumentIconDefinition}
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
