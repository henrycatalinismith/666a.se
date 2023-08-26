import Link from 'next/link'

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../../components/ui/table'
import { lookupCasesByCompanyId } from '../../../lib/case'
import { lookupCompanyByCode } from '../../../lib/company'
import { Company } from '../../../lib/database'

export default async function Company({ params }: any) {
  const company = await lookupCompanyByCode({ code: params.code })
  const cases = await lookupCasesByCompanyId({
    companyId: company.id as any as number,
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
