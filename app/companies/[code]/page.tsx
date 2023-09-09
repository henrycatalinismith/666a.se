import { faBoxArchive, faPeopleGroup } from '@fortawesome/free-solid-svg-icons'
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
          <IconHeading
            icon={faPeopleGroup}
            title={company.name}
            subtitle={company.code}
          />
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
                  <IconLink href={`/cases/${c.code}`} icon={faBoxArchive}>
                    {c.code}
                  </IconLink>
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
