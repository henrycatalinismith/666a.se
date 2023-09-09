import { faBoxArchive } from '@fortawesome/free-solid-svg-icons'
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

export default async function Ingestion() {
  const documents = await prisma.document.findMany({
    orderBy: { created: 'desc' },
    include: { case: true, type: true, company: true },
    take: 64,
  })

  return (
    <>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="text-left">Date</TableHead>
            <TableHead className="text-left">Case</TableHead>
            <TableHead className="text-left">Type</TableHead>
            <TableHead className="text-left">Company</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {documents.map((d) => (
            <TableRow key={d.id}>
              <TableCell className="whitespace-nowrap">
                {d.date.toISOString().substring(0, 10)}
              </TableCell>
              <TableCell>
                <IconLink href={`/cases/${d.case?.code}`} icon={faBoxArchive}>
                  {d.case?.name}
                </IconLink>
              </TableCell>
              <TableCell>{d.type.name}</TableCell>
              <TableCell>{d.company?.name}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </>
  )
}
