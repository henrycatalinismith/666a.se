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
  const totals: Record<string, number> = {}
  totals.Cases = await prisma.case.count()
  totals.Chunks = await prisma.chunk.count()
  totals.Companies = await prisma.company.count()
  totals.Documents = await prisma.document.count()
  totals.Errors = await prisma.error.count()
  totals.Municipalities = await prisma.municipality.count()
  totals.Scans = await prisma.scan.count()
  totals.Sessions = await prisma.session.count()
  totals.Stubs = await prisma.stub.count()
  totals.Ticks = await prisma.tick.count()
  totals.Users = await prisma.user.count()
  totals.Workplaces = await prisma.workplace.count()

  return (
    <>
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead className="text-left">Entity</TableHead>
            <TableHead className="text-left">Total</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {Object.keys(totals).map((k) => (
            <TableRow key={k}>
              <TableCell>{k}</TableCell>
              <TableCell>{totals[k]}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </>
  )
}
