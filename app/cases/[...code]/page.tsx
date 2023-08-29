import Link from 'next/link'

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../../components/ui/table'
import { requireUser } from '../../../lib/authentication'
import prisma from '../../../lib/database'

export default async function Case({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const c = await prisma.case.findFirstOrThrow({
    where: {
      code: params.code.join('/'),
    },
  })
  const company = await prisma.company.findFirstOrThrow({
    where: { id: c.companyId },
  })
  const documents = await prisma.document.findMany({
    where: {
      caseId: c.id,
    },
  })

  return (
    <>
      <div className="container pt-8">
        <div className="space-y-3">
          <h1 className="scroll-m-20 text-4xl font-bold tracking-tight">
            {c!.code}
          </h1>
          <p className="text-lg text-muted-foreground">{c!.name}</p>
        </div>

        <p className="pt-8">
          <Link href={`/companies/${company.code}`}>{company.name}</Link>
        </p>

        <h2 className="pt-2 font-heading mt-8 scroll-m-20 text-xl font-semibold tracking-tight">
          Documents
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-left">Date</TableHead>
              <TableHead className="text-left">Type</TableHead>
              <TableHead className="text-left">Filing ID</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {documents.map((document: any) => (
              <TableRow key={document.id}>
                <TableCell>{document.filed.toISOString()}</TableCell>
                <TableCell>{document.type}</TableCell>
                <TableCell>{document.code}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
