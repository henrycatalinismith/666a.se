import Link from 'next/link'

import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../../components/ui/table'
import { lookupCaseByCode } from '../../../lib/case'
import { lookupCompanyById } from '../../../lib/company'
import { lookupDocumentsByCaseId } from '../../../lib/document'

export default async function Case({ params }: any) {
  const c = await lookupCaseByCode({ code: params.code.join('/') })
  const company = await lookupCompanyById({ id: c!.company_id })
  const documents = await lookupDocumentsByCaseId({
    caseId: c!.id as any as number,
  })

  return (
    <>
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
              <TableCell>{document.filed}</TableCell>
              <TableCell>{document.type}</TableCell>
              <TableCell>{document.code}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </>
  )
}
