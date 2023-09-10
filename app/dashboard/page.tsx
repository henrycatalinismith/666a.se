import { ErrorStatus, ScanStatus } from '@prisma/client'
import { Progress } from '@radix-ui/react-progress'
import { DashboardError } from 'components/DashboardError'
import { DashboardScan } from 'components/DashboardScan'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { Card } from 'ui/Card'
import NavBar from 'ui/NavBar'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from 'ui/Table'

export default async function Dashboard() {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  const scan = await prisma.scan.findFirst({
    where: { status: ScanStatus.ONGOING },
    include: {
      county: true,
      chunks: { include: { county: true }, orderBy: { page: 'asc' } },
    },
  })

  // const subscriptions = await prisma.subscription.findMany({

  //   where: { userId: user.id },
  //   include: { company: true },
  // })

  const documents = await prisma.document.findMany({
    orderBy: { date: 'desc' },
    take: 4,
    include: { case: true, company: true, type: true },
  })

  const blockingError = await prisma.error.findFirst({
    where: { status: ErrorStatus.BLOCKING },
  })

  // const notifications = await findNewNotificationsByUserId({
  //   user_id: session!.user.id as any as number,
  // })

  // const documents = await Promise.all(
  // notifications.map((n) => findDocumentById({ id: n.target_id }))
  // )
  // const documentsById = _.keyBy(documents, 'id')

  // this is shit. kysely is terrible for joins
  // const newd = await findDocumentsByIdWithCaseAndCompany({
  // ids: _.map(notifications, 'target_id'),
  // })
  // console.log(newd)

  return (
    <>
      <NavBar />

      <div className="container">
        {scan && (
          <DashboardScan
            chunks={scan.chunks}
            county={scan.county}
            scan={scan}
          />
        )}
        {blockingError && <DashboardError error={blockingError} />}

        <h2>Documents</h2>
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="text-left">Date</TableHead>
              <TableHead className="text-left">Type</TableHead>
              <TableHead className="text-left">Company</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {documents.map((doc) => (
              <TableRow key={doc.id}>
                <TableCell>{doc.date.toISOString().substring(0, 10)}</TableCell>
                <TableCell>{doc.type.name}</TableCell>
                <TableCell>{doc.company?.name}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </>
  )
}
