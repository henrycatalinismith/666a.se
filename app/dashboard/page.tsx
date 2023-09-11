import { ErrorStatus, ScanStatus } from '@prisma/client'
import { DashboardError } from 'components/DashboardError'
import { DashboardScan } from 'components/DashboardScan'
import { DocumentIconDefinition } from 'entities/Document'
import { requireUser } from 'lib/authentication'
import prisma from 'lib/database'
import { EntityList } from 'ui/EntityList'
import { LittleHeading } from 'ui/LittleHeading'
import NavBar from 'ui/NavBar'

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
    orderBy: { created: 'desc' },
  })

  // const subscriptions = await prisma.subscription.findMany({

  //   where: { userId: user.id },
  //   include: { company: true },
  // })

  const documents = await prisma.document.findMany({
    orderBy: { created: 'desc' },
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

      <div className="container flex flex-col gap-8">
        {scan && (
          <DashboardScan
            chunks={scan.chunks}
            county={scan.county}
            scan={scan}
          />
        )}
        {blockingError && <DashboardError error={blockingError} />}

        <LittleHeading>Latest Documents</LittleHeading>
        <EntityList
          items={documents.map((document) => ({
            icon: DocumentIconDefinition,
            href: `/documents/${document.code}`,
            text: document.type.name,
            subtitle: document.date.toISOString().substring(0, 10),
            show: true,
          }))}
        />
      </div>
    </>
  )
}
