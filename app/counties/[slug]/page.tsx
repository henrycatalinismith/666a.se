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

export default async function County({ params }: any) {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const county = await prisma.county.findFirstOrThrow({
    where: { slug: params.slug },
    include: { municipalities: true },
  })

  return (
    <>
      <div className="container pt-8">
        <div className="space-y-3">
          <h1 className="scroll-m-20 text-4xl font-bold tracking-tight">
            {county.name}
          </h1>
          <p className="text-lg text-muted-foreground">{county.code}</p>
        </div>

        <h2 className="pt-8 font-heading mt-8 scroll-m-20 text-xl font-semibold tracking-tight">
          Municipalities
        </h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>?</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {county.municipalities.map((m: any) => (
              <TableRow key={m.id}>
                <TableCell>
                  <Link href={`/municipalities/${m.slug}`}>{m.name}</Link>
                </TableCell>
                <TableCell>{m.code}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
