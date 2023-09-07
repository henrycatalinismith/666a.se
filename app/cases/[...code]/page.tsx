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

export default async function Case({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const c = await prisma.case.findFirstOrThrow({
    where: { code: params.code.join('/') },
    include: { company: true },
  })

  const documents = await prisma.document.findMany({
    where: { caseId: c.id },
    include: { type: true },
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

        {c.company && (
          <p className="pt-8">
            <Link href={`/companies/${c.company.code}`}>{c.company.name}</Link>
          </p>
        )}

        <h2 className="pt-2 font-heading mt-8 scroll-m-20 text-xl font-semibold tracking-tight">
          Documents
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-left">ID</TableHead>
              <TableHead className="text-left">Type</TableHead>
              <TableHead className="text-left">Filing ID</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {documents.map((document: any) => (
              <TableRow key={document.id}>
                <TableCell>
                  <Link href={`/documents/${document.code}`}>
                    {document.code}
                  </Link>
                </TableCell>
                <TableCell>{document.type.name}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
