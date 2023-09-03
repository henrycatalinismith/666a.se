import NavBar from '../../components/NavBar'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '../../components/Table'
import { requireUser } from '../../lib/authentication'
import prisma from '../../lib/database'

export default async function Dashboard() {
  const user = await requireUser()
  if (!user) {
    return <></>
  }

  // const subscriptions = await prisma.subscription.findMany({
  //   where: { userId: user.id },
  //   include: { company: true },
  // })

  const documents = await prisma.document.findMany({
    orderBy: { date: 'desc' },
    take: 4,
    include: { case: true, company: true, type: true },
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
