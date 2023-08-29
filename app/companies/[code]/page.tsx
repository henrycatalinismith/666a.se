import Link from 'next/link'

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

export default async function Company({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const company = await prisma.company.findFirstOrThrow({
    where: { code: params.code },
  })
  const cases = await prisma.case.findMany({
    where: { companyId: company.id },
  })

  return (
    <>
      <div className="container pt-8">
        <div className="space-y-3">
          <h1 className="scroll-m-20 text-4xl font-bold tracking-tight">
            {company.name}
          </h1>
          <p className="text-lg text-muted-foreground">{company.code}</p>
        </div>

        <h2 className="pt-8 font-heading mt-8 scroll-m-20 text-xl font-semibold tracking-tight">
          Case History
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Case ID</TableHead>
              <TableHead>Topic</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {cases.map((c: any) => (
              <TableRow key={c.id}>
                <TableCell>
                  <Link href={`/cases/${c.code}`}>{c.code}</Link>
                </TableCell>
                <TableCell>{c.name}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
